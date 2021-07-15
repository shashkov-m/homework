import UIKit
import RealmSwift
import SDWebImage
import FirebaseFirestore
class NewsfeedTableViewController: UITableViewController {
    
    private let newsfeedRequest = NewsfeedRequest ()
    private var news:Results<NewsfeedRealmEntuty>?
    private var token:NotificationToken?
    private let firestore = Firestore.firestore()
    private var realm = try? Realm ()
    private var date = Date()
    private var df = DateFormatter ()
    private var firebaseDf = DateFormatter ()
    private let bgColorView = UIView()
    private let cache = NSCache <NSString, UIImage> ()
    private var isLoading = false
    private var startTime:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        isLoading = true
        newsfeedRequest.getNewsfeed(startFrom: nil) {[weak self] completion in
            if completion == true  { self?.isLoading = false }
        }
        df.dateStyle = .medium
        df.timeStyle = .short
        df.doesRelativeDateFormatting = true
        tableView.prefetchDataSource = self
        bgColorView.backgroundColor = UIColor.clear
        setupRefreshControl()
        
        do {
            realm = try Realm ()
            news = realm?.objects(NewsfeedRealmEntuty.self)
            startTime = news?.first?.date ?? 0
            print (realm?.configuration.fileURL)
        } catch {
            print (error.localizedDescription)
        }
        
        token = news?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.tableView.reloadData()
            case .error(let error):
                print (error.localizedDescription)
            }
        }
        firebaseDf.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateString = firebaseDf.string(from: date)
        firestore.collection("users").document(Session.session.userId).setData(["last auth":"\(dateString)"]) { error in
            if let error = error {
                print ("firestore error: \(error)")
            } else {
                print ("firestore data write success")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userNews = news else {return UITableViewCell ()}
        let news = userNews [indexPath.section]
        
        //MARK:- GIF
        if news.attachments.count == 1, news.attachments[0].type == "doc" {
            tableView.register(UINib (nibName: "GifTableViewCell", bundle: nil),forCellReuseIdentifier: "gifCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell", for: indexPath) as! GifTableViewCell
            cell.selectedBackgroundView = bgColorView
            cell.postLabel.text = news.text
            cell.backgroundColor = .systemBackground
            cell.gifView.frame = cell.view.bounds
            cell.view.addSubview(cell.gifView)
            guard let source = news.attachments.first?.source else { return cell }
            let url = URL(string: source)
            cell.gifView.sd_setImage(with: url, placeholderImage: nil) {image,error,cacheType,url  in
                if image != nil {
                    cell.gifView.startAnimating()
                } else {
                    guard error != nil else { return }
                    cell.gifView.sd_cancelCurrentImageLoad()
                }
            }
            return cell
            //MARK:- Photos
        } else if news.attachments.count >= 1, news.attachments[0].type == "photo"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedTableViewCell", for: indexPath) as! NewsfeedUITableViewCell
            cell.selectedBackgroundView = bgColorView
            cell.postLabel.text = news.text
            cell.backgroundColor = .systemBackground
            return cell
            //MARK: Default
        } else {
            tableView.register(UINib (nibName: "DefaultTableViewCell", bundle: nil),forCellReuseIdentifier: "defaultCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! DefaultTableViewCell
            cell.selectedBackgroundView = bgColorView
            cell.postLabel.text = news.text
            cell.backgroundColor = .systemBackground
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NewsfeedUITableViewCell {
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
        } else if let cell = cell as? GifTableViewCell {
            if cell.gifView.image != nil {
                cell.gifView.startAnimating()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? GifTableViewCell {
            cell.gifView.stopAnimating()
            cell.gifView.sd_cancelCurrentImageLoad()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? GifTableViewCell {
            if cell.gifView.isAnimating != true {
                cell.gifView.startAnimating()
                
            } else {
                cell.gifView.stopAnimating()
            }
        }
    }
    
    deinit {
        token?.invalidate()
    }
}
extension NewsfeedTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: CollectionView Delegate & DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let userNews = news? [collectionView.tag]
        if let attachmentsCount:Int = userNews?.attachments.count {
            return attachmentsCount > 4 ? 4 : attachmentsCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib (nibName: "NewsfeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsfeedCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsfeedCollectionViewCell", for: indexPath) as! NewsfeedCollectionViewCell
        guard let userNews = news? [collectionView.tag] else {return cell}
        let attachCount = userNews.attachments.count
        if let url = userNews.attachments[indexPath.item].source {
            getImage(url: url) { image in
                DispatchQueue.main.async {
                    cell.image.image = image
                }
            }
        }
        if attachCount > 4, indexPath.item == 3{
            cell.countLabel.frame = cell.bounds
            cell.countLabel.text = "+\(attachCount - indexPath.item)"
            cell.image.alpha = 0.35
            cell.addSubview(cell.countLabel)
        }
        return cell
    }
    
    private func getImage (url: String, completion: @escaping (UIImage) -> Void) {
        let key = NSString (string: url)
        let url = URL (string: url)!
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let image = self?.cache.object(forKey: key) {
                completion (image)
            }
            
            else {
                do {
                    let data = try Data (contentsOf: url)
                    if let image = UIImage (data: data) {
                        self?.cache.setObject(image, forKey: key)
                        completion (image)
                    }
                }
                
                catch {
                    print (error.localizedDescription)
                }
            }
        }
    }
    
}

extension NewsfeedTableViewController {
    //MARK: Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let userNews = news else { return nil}
        let news = userNews [section]
        let owner = realm?.objects(NewsfeedRealmOwner.self).filter("id == \(news.id)")
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .systemBackground
        let avatarView = UIImageView.init(frame: CGRect.init(x: 6, y: 0, width: 50, height: 50))
        let avatarLabel = UILabel ()
        let dateLabel = UILabel ()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(avatarView)
        headerView.addSubview(avatarLabel)
        headerView.addSubview(dateLabel)
        
        avatarLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 6).isActive = true
        avatarLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 8).isActive = true
        dateLabel.topAnchor.constraint(equalTo: avatarLabel.bottomAnchor, constant: 1).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 8).isActive = true
        
        let groupPhoto = owner?.first?.photo ?? ""
        let groupName = owner?.first?.name ?? ""
        
        let url = URL(string: groupPhoto)
        
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = 25
        
        date = Date(timeIntervalSince1970: Double(news.date))
        let dateString = df.string(from: date)
        avatarView.sd_setImage(with: url)
        avatarLabel.text = groupName
        dateLabel.text = "\(dateString)"
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let userNews = news else { return nil}
        let news = userNews [section]
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        footerView.backgroundColor = .systemBackground
        
        let likeView = UIImageView()
        let likeLabel = UILabel()
        let commentView = UIImageView()
        let commentLabel = UILabel()
        let shareView = UIImageView()
        let shareLabel = UILabel()
        let viewsView = UIImageView()
        let viewsLabel = UILabel()
        
        let tintColour = UIColor.gray
        let viewsArray = [likeView,likeLabel,commentView,commentLabel,shareView,shareLabel,viewsView,viewsLabel]
        for view in viewsArray {
            view.tintColor = tintColour
            view.translatesAutoresizingMaskIntoConstraints = false
            footerView.addSubview(view)
        }
        footerView.addSubview(likeView)
        let imageViewSize = CGSize (width: 20.0, height: 20.0)
        
        likeView.frame.size = imageViewSize
        commentView.frame.size = imageViewSize
        shareView.frame.size = imageViewSize
        viewsView.frame.size = imageViewSize
        
        likeView.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 6).isActive = true
        likeView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5).isActive = true
        likeLabel.leftAnchor.constraint(equalTo: likeView.rightAnchor, constant: 3).isActive = true
        likeLabel.topAnchor.constraint(equalTo: footerView.topAnchor,constant: 5).isActive = true
        
        commentView.leftAnchor.constraint(equalTo: likeLabel.rightAnchor, constant: 10).isActive = true
        commentView.topAnchor.constraint(equalTo: footerView.topAnchor,constant: 5).isActive = true
        commentLabel.leftAnchor.constraint(equalTo: commentView.rightAnchor, constant: 3).isActive = true
        commentLabel.topAnchor.constraint(equalTo: footerView.topAnchor,constant: 5).isActive = true
        
        shareView.leftAnchor.constraint(equalTo: commentLabel.rightAnchor, constant: 10).isActive = true
        shareView.topAnchor.constraint(equalTo: footerView.topAnchor,constant: 5).isActive = true
        shareLabel.leftAnchor.constraint(equalTo: shareView.rightAnchor, constant: 3).isActive = true
        shareLabel.topAnchor.constraint(equalTo: footerView.topAnchor,constant: 5).isActive = true
        
        viewsLabel.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -6).isActive = true
        viewsLabel.topAnchor.constraint(equalTo: footerView.topAnchor,constant: 5).isActive = true
        viewsView.rightAnchor.constraint(equalTo: viewsLabel.leftAnchor, constant: -3).isActive = true
        viewsView.topAnchor.constraint(equalTo: footerView.topAnchor,constant: 5).isActive = true
        
        likeView.image = news.user_likes == 0 ? UIImage (systemName: "heart") : UIImage (systemName: "heart.fill")
        commentView.image = UIImage (systemName: "bubble.left")
        shareView.image = UIImage (systemName: "arrowshape.turn.up.right")
        viewsView.image = UIImage (systemName: "eye")
        likeLabel.text = "\(news.likes)"
        viewsLabel.text = "\(news.views)"
        shareLabel.text = "\(news.reposts)"
        commentLabel.text = "\(news.comments)"
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

extension NewsfeedTableViewController: UITableViewDataSourcePrefetching {
    private func setupRefreshControl () {
        refreshControl = UIRefreshControl ()
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc private func refreshNews () {
        self.refreshControl?.beginRefreshing()
        NewsfeedRequest.nextFrom = nil
        newsfeedRequest.getNewsfeed(startFrom: nil) {_ in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max(), let news = news else { return }
        if maxSection > news.count - 4, !isLoading {
            isLoading = true
            newsfeedRequest.getNewsfeed(startFrom: NewsfeedRequest.nextFrom) {[weak self] completion in
                if completion == true  { self?.isLoading = false }
            }
        }
    }
    
}

import UIKit
import RealmSwift
import SDWebImage
class NewsfeedTableViewController: UITableViewController {
    
    let newsfeedRequest = NewsfeedRequest ()
    var news:Results<NewsfeedRealmEntuty>?
    var token:NotificationToken?
    let queue = DispatchQueue (label: "NewsFeedCellQueue", qos: .userInteractive, attributes: .concurrent)
    var realm = try? Realm ()
    var date = Date()
    var df = DateFormatter ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = true
        newsfeedRequest.getNewsfeed()
        df.dateFormat = "dd.MM.yyyy HH:mm"
        
        do {
            realm = try Realm ()
            news = realm?.objects(NewsfeedRealmEntuty.self)
        } catch {
            print (error.localizedDescription)
        }
        
        token = news?.observe {[weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.tableView.reloadData()
            case .error(let error):
                print (error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // guard let userNews = news else {return UITableViewCell ()}
        // let news = userNews [indexPath.row]
        guard let userNews = news else {return UITableViewCell ()}
        let news = userNews [indexPath.row]
        
        //MARK:- GIF
        if news.attachments.count == 1, news.attachments[0].type == "doc" {
            tableView.register(UINib (nibName: "GifTableViewCell", bundle: nil),forCellReuseIdentifier: "gifCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell", for: indexPath) as! GifTableViewCell
            guard let source = news.attachments.first?.source else { return cell }
            cell.gifView.frame = cell.view.bounds
            cell.view.addSubview(cell.gifView)
            cell.gifView.sd_setImage(with: URL(string: source), placeholderImage: nil) {image,error,cacheType,url  in
                if image != nil {
                    cell.gifView.startAnimating()
                } else {
                    guard error != nil else {return}
                    cell.gifView.sd_cancelCurrentImageLoad()
                }
            }
            cellConfigure(cell: cell, indexPath: indexPath)
            return cell
            
        } else if news.attachments.count >= 1, news.attachments[0].type == "photo"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedTableViewCell", for: indexPath) as! NewsfeedUITableViewCell
            return cell
        }
        return UITableViewCell ()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NewsfeedUITableViewCell {
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
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
    
    func cellConfigure (cell: NewsfeedCell, indexPath:IndexPath) {
        guard let userNews = news else { return }
        let news = userNews [indexPath.row]
        
        cell.likeView.image = news.user_likes == 0 ? UIImage (systemName: "heart") : UIImage (systemName: "heart.fill")
        cell.commentView.image = UIImage (systemName: "bubble.left")
        cell.repostView.image = UIImage (systemName: "arrowshape.turn.up.right")
        cell.viewsView.image = UIImage (systemName: "eye")
        cell.likeLabel.text = "\(news.likes)"
        cell.viewsLabel.text = "\(news.views)"
        cell.repostLabel.text = "\(news.reposts)"
        cell.commentLabel.text = "\(news.comments)"
        cell.repostView.tintColor = .gray
        cell.viewsView.tintColor = .gray
        cell.commentView.tintColor = .gray
        cell.likeView.tintColor = .gray
        
        let owner = realm?.objects(NewsfeedRealmOwner.self).filter("id == \(news.id)")
        let groupPhoto = owner?.first?.photo ?? ""
        let groupName = owner?.first?.name ?? ""
        
        let avatarUrl = URL(string: groupPhoto)
        
        cell.avatarView.layer.masksToBounds = true
        cell.avatarView.layer.cornerRadius = 20
        
        date = Date(timeIntervalSince1970: Double(news.date))
        let dateString = df.string(from: date)
        
        cell.dateLabel.text = "\(dateString)"
        cell.postLabel.text = news.text
        cell.nameLabel.text = groupName
        cell.avatarView.sd_setImage(with: avatarUrl)
    }
}

extension NewsfeedTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let userNews = news? [collectionView.tag]
        return userNews?.attachments.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib (nibName: "NewsfeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "newsfeedCollectionViewCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsfeedCollectionViewCell", for: indexPath) as! NewsfeedCollectionViewCell
        cell.backgroundColor = .black
        return cell
    }
}

extension NewsfeedTableViewController: CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 400.0
    }
    
    
}

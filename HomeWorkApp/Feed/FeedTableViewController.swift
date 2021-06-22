import UIKit
import RealmSwift
import SDWebImage
class FeedTableViewController: UITableViewController {
        
    let newsfeedRequest = NewsfeedRequest ()
    var news:Results<NewsfeedRealmEntuty>?
    var token:NotificationToken?
    let queue = DispatchQueue (label: "NewsFeedCellQueue", qos: .userInteractive, attributes: .concurrent)
    var realm = try? Realm ()
    
    let cache = NSCache <NSString, UIImage> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        newsfeedRequest.getNewsfeed()
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
        cache.name = "Newsfeed cache"
        cache.countLimit = 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userNews = news else {return UITableViewCell ()}
        
        let news = userNews [indexPath.row]
        
        // GIF
        if news.attachments.count == 1, news.attachments[0].type == "doc" {
            tableView.register(UINib (nibName: "GifTableViewCell", bundle: nil),forCellReuseIdentifier: "gifCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "gifCell", for: indexPath) as! GifTableViewCell
            guard let source = news.attachments.first?.source else { return cell }
            cell.gifView.frame = cell.view.bounds
            cell.view.addSubview(cell.gifView)
            getImage(GIF: source) {image in
                DispatchQueue.main.async {
                    cell.gifView.image = image
                }
            }
            cellConfigure(cell: cell, indexPath: indexPath)
            return cell
            
            //1 Image
        } else if news.attachments.count == 1, news.attachments[0].type == "photo"{
            tableView.register(UINib (nibName: "OneImgTableViewCell", bundle: nil),forCellReuseIdentifier: "oneImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "oneImg", for: indexPath) as! OneImgTableViewCell
            guard let source = news.attachments.first?.source else { return cell }
            let url = URL(string: source) ?? URL (string: "")
            
            queue.async {
                if let data = try? Data (contentsOf: url!) {
                    if let image = UIImage (data: data) {
                        DispatchQueue.main.async {
                            cell.imgView.image = image
                        }
                    }
                }
            }
            
            cellConfigure(cell: cell, indexPath: indexPath)
            return cell
            
            // 2 Images
        } else if news.attachments.count == 2, news.attachments.allSatisfy({$0.type == "photo"}) {
            tableView.register(UINib (nibName: "TwoImgTableViewCell", bundle: nil),forCellReuseIdentifier: "twoImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoImg", for: indexPath) as! TwoImgTableViewCell
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source else { return cell }
            let fUrl = URL(string: fsource)
            let sUrl = URL(string: ssource)
            
            queue.async {
                if let data = try? Data (contentsOf: fUrl!) {
                    if let image = UIImage (data: data) {
                        DispatchQueue.main.async {
                            cell.firstImg.image = image
                        }
                    }
                }
            }
            
            queue.async {
                if let data = try? Data (contentsOf: sUrl!) {
                    if let image = UIImage (data: data) {
                        DispatchQueue.main.async {
                            cell.secondImg.image = image
                        }
                    }
                }
            }
            
            cellConfigure(cell: cell, indexPath: indexPath)
            
            return cell
            
            //3 Images
        } else if news.attachments.count == 3, news.attachments.allSatisfy({$0.type == "photo"}){
            tableView.register(UINib (nibName: "ThreeImgTableViewCell", bundle: nil),forCellReuseIdentifier: "threeImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "threeImg", for: indexPath) as! ThreeImgTableViewCell
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source, let tsource = news.attachments[2].source else { return cell }
            let fUrl = URL(string: fsource) ?? URL(string: "")!
            let sUrl = URL(string: ssource) ?? URL(string: "")!
            let tUrl = URL(string: tsource) ?? URL(string: "")!
            
            asyncImageLoad(url: fUrl) { image in
                cell.firstImg.image = image
            }
            
            asyncImageLoad(url: sUrl) { image in
                cell.secondImg.image = image
            }
            
            asyncImageLoad(url: tUrl) { image in
                cell.thirdImg.image = image
            }
            
            cellConfigure(cell: cell, indexPath: indexPath)
            return cell
            
            //4 and more Images
        } else if news.attachments.count >= 4, news.attachments.allSatisfy({$0.type == "photo"}){
            
            tableView.register(UINib (nibName: "FourImgTableViewCell", bundle: nil),forCellReuseIdentifier: "fourImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "fourImg", for: indexPath) as! FourImgTableViewCell
            
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source, let tsource = news.attachments[2].source, let frthsource = news.attachments[3].source else { return cell }
            
            let fUrl = URL(string: fsource) ?? URL(string: "")!
            let sUrl = URL(string: ssource) ?? URL(string: "")!
            let tUrl = URL(string: tsource) ?? URL(string: "")!
            let frthUrl = URL(string: frthsource) ?? URL(string: "")!
            
            asyncImageLoad(url: fUrl) { image in
                cell.firstImg.image = image
            }
            asyncImageLoad(url: sUrl) { image in
                cell.secondImg.image = image
            }
            asyncImageLoad(url: tUrl) { image in
                cell.thirdImg.image = image
            }
            asyncImageLoad(url: frthUrl) { image in
                cell.fourthImg.image = image
            }
            
            cellConfigure(cell: cell, indexPath: indexPath)
            
            if news.attachments.count > 4 {
                cell.countLabel.frame = cell.fourthImg.frame
                cell.fourthImg.alpha = 0.35
                cell.countLabel.text = "+\(news.attachments.count - 3)"
                
                cell.imageContainer.addSubview(cell.countLabel)
            }
            return cell
            
        } else {
            print ("The cell wasn't configure.\nAttach element count = \(news.attachments.count)\nNews id = \(news.id)" )
        }
        return UITableViewCell ()
    }
    
    //    //Отменяет загрузку GIF когда быстро пролистывается лента и GIF пропадает из вида, так и не загрузившись
    //    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)  {
    //        if let cell = cell as? GifTableViewCell {
    //            cell.gifView.sd_cancelCurrentImageLoad()
    //        }
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
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
        
        let date = Date(timeIntervalSince1970: Double(news.date))
        let df = DateFormatter ()
        df.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = df.string(from: date)
        
        cell.dateLabel.text = "\(dateString)"
        cell.postLabel.text = news.text
        cell.nameLabel.text = groupName
        cell.avatarView.sd_setImage(with: avatarUrl)
    }
    
    func asyncImageLoad (url:URL, completion: @escaping (UIImage) -> Void) {
        
        queue.async {
            
            if let data = try? Data (contentsOf: url) {
                
                if let image = UIImage (data: data) {
                    DispatchQueue.main.async {
                        completion (image)
                    }
                }
            }
        }
    }
}

extension FeedTableViewController {
    
    func getImage (GIF url:String, completion: @escaping (UIImage) -> Void) {
        let key = NSString(string: url)
        let url = URL(string: url)
        
        if let image = cache.object(forKey: key) {
            print ("Картинка из кэша 🧤")
            completion (image)
        } else {
            guard let url = url else {
                print ("URL is empty")
                return completion (SDAnimatedImage ())
            }
            print ("Грузим гифку 🎒")
            queue.async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = SDAnimatedImage (data: data) {
                        self?.cache.setObject(image, forKey: key)
                        completion (image)
                    }
                }
            }
        }
    }
}

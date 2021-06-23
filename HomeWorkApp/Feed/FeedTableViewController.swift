import UIKit
import RealmSwift
import SDWebImage
class FeedTableViewController: UITableViewController {
    
    let newsfeedRequest = NewsfeedRequest ()
    var news:Results<NewsfeedRealmEntuty>?
    var token:NotificationToken?
    let queue = DispatchQueue (label: "NewsFeedCellQueue", qos: .userInteractive, attributes: .concurrent)
    var realm = try? Realm ()
    var date = Date()
    var df = DateFormatter ()
    
    
    let cache = NSCache <NSString, UIImage> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
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
        cache.countLimit = 500
        df.dateFormat = "dd.MM.yyyy HH:mm"
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
            
            //MARK:- 1 Image
        } else if news.attachments.count == 1, news.attachments[0].type == "photo"{
            tableView.register(UINib (nibName: "OneImgTableViewCell", bundle: nil),forCellReuseIdentifier: "oneImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "oneImg", for: indexPath) as! OneImgTableViewCell
            guard let source = news.attachments.first?.source else { return cell }
            
            getImage(firstImage: source, secondImage: nil, thirthImage: nil, fourthImage: nil) { images in
                DispatchQueue.main.async {
                    cell.imgView.image = images.first
                }
            }
            
            cellConfigure(cell: cell, indexPath: indexPath)
            return cell
            
            //MARK:- 2 Images
        } else if news.attachments.count == 2, news.attachments.allSatisfy({$0.type == "photo"}) {
            tableView.register(UINib (nibName: "TwoImgTableViewCell", bundle: nil),forCellReuseIdentifier: "twoImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoImg", for: indexPath) as! TwoImgTableViewCell
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source else { return cell }
            getImage(firstImage: fsource, secondImage: ssource, thirthImage: nil, fourthImage: nil) {images in
                DispatchQueue.main.async {
                    cell.firstImg.image = images[0]
                    cell.secondImg.image = images[1]
                }
            }
            cellConfigure(cell: cell, indexPath: indexPath)
            
            return cell
            
            //MARK:- 3 Images
        } else if news.attachments.count == 3, news.attachments.allSatisfy({$0.type == "photo"}){
            tableView.register(UINib (nibName: "ThreeImgTableViewCell", bundle: nil),forCellReuseIdentifier: "threeImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "threeImg", for: indexPath) as! ThreeImgTableViewCell
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source, let tsource = news.attachments[2].source else { return cell }
            getImage(firstImage: fsource, secondImage: ssource, thirthImage: tsource, fourthImage: nil) {images in
                DispatchQueue.main.async {
                    cell.firstImg.image = images[0]
                    cell.secondImg.image = images[1]
                    cell.thirdImg.image = images[2]
                }
            }
            cellConfigure(cell: cell, indexPath: indexPath)
            return cell
            
            //MARK:- 4 and more Images
        } else if news.attachments.count >= 4, news.attachments.allSatisfy({$0.type == "photo"}){
            
            tableView.register(UINib (nibName: "FourImgTableViewCell", bundle: nil),forCellReuseIdentifier: "fourImg")
            let cell = tableView.dequeueReusableCell(withIdentifier: "fourImg", for: indexPath) as! FourImgTableViewCell
            
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source, let tsource = news.attachments[2].source, let frthsource = news.attachments[3].source else { return cell }
            
            getImage(firstImage: fsource, secondImage: ssource, thirthImage: tsource, fourthImage: frthsource) {images in
                DispatchQueue.main.async {
                    cell.firstImg.image = images[0]
                    cell.secondImg.image = images[1]
                    cell.thirdImg.image = images[2]
                    cell.fourthImg.image = images[3]
                }
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? GifTableViewCell {
            if cell.gifView.image != nil {
                cell.gifView.startAnimating()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)  {
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
        
        date = Date(timeIntervalSince1970: Double(news.date))
        let dateString = df.string(from: date)
        
        cell.dateLabel.text = "\(dateString)"
        cell.postLabel.text = news.text
        cell.nameLabel.text = groupName
        cell.avatarView.sd_setImage(with: avatarUrl)
    }
}



extension FeedTableViewController {
    func getImage (firstImage:String,secondImage:String?,thirthImage:String?,fourthImage:String?, completion: @escaping ([UIImage]) -> Void) {
        //Считаем кол-во картинок к загрузке
        var imgCount:Int {
            get {
                if secondImage != nil, thirthImage != nil, fourthImage != nil {
                    return 4
                } else if secondImage != nil, thirthImage != nil {
                    return 3
                } else if secondImage != nil {
                    return 2
                } else {
                    return 1
                }
            }
        }
        var imageArray:[UIImage] = []
        //В зависимости от полученного кол-ва картинок проводим их загрузку
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            switch imgCount {
            case 4:
                let key = NSString(string: fourthImage!)
                let url = URL(string: fourthImage!)
                if let image = self?.cache.object (forKey: key) {
                    imageArray.append(image)
                } else {
                    guard let url = url else { print ("URL is empty"); break}
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage (data: data) {
                            self?.cache.setObject(image, forKey: key)
                            imageArray.append(image)
                        }
                    }
                }
                fallthrough
            case 3:
                let key = NSString(string: thirthImage!)
                let url = URL(string: thirthImage!)
                if let image = self?.cache.object (forKey: key) {
                    imageArray.append(image)
                } else {
                    guard let url = url else { print ("URL is empty"); break}
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage (data: data) {
                            self?.cache.setObject(image, forKey: key)
                            imageArray.append(image)
                        }
                    }
                }
                fallthrough
            case 2:
                let key = NSString(string: secondImage!)
                let url = URL(string: secondImage!)
                if let image = self?.cache.object (forKey: key) {
                    imageArray.append(image)
                } else {
                    guard let url = url else { print ("URL is empty"); break}
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage (data: data) {
                            self?.cache.setObject(image, forKey: key)
                            imageArray.append(image)
                        }
                    }
                }
                fallthrough
            case 1:
                let key = NSString(string: firstImage)
                let url = URL(string: firstImage)
                if let image = self?.cache.object (forKey: key) {
                    imageArray.append(image)
                } else {
                    guard let url = url else { print ("URL is empty"); break}
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage (data: data) {
                            self?.cache.setObject(image, forKey: key)
                            imageArray.append(image)
                        }
                    }
                }
                //Выдаем получившийся массив картинок
                completion (imageArray.reversed())
                break
            default:
                break
            }
        }
    }
}

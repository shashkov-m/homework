import UIKit
import RealmSwift
import Kingfisher
import SDWebImage
class FeedTableViewController: UITableViewController {
    let date = Date ()
    let df = DateFormatter ()
    let newsfeedRequest = NewsfeedRequest ()
    var news:Results<NewsfeedRealmEntuty>?
    let realm = try! Realm ()
    var token:NotificationToken?
    let queue = DispatchQueue (label: "NewsFeedCellQueue", qos: .userInteractive, attributes: .concurrent)
    let dispatchGroup = DispatchGroup ()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        newsfeedRequest.getNewsfeed()
        news = realm.objects(NewsfeedRealmEntuty.self)
        df.dateFormat = "dd.MM.yyyy HH:mm"
        tableView.allowsSelection = false
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
    
    @IBAction func reloadButton(_ sender: Any) {
        newsfeedRequest.getNewsfeed()
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        guard let userNews = news else {return cell}
        let news = userNews [indexPath.row]
        let owner = realm.objects(NewsfeedRealmOwner.self).filter("id == \(news.id)")
        let groupPhoto = owner.first?.photo ?? ""
        let groupName = owner.first?.name ?? ""
        
        let avatarUrl = URL(string: groupPhoto)
        cell.avatarView.layer.masksToBounds = true
        cell.avatarView.layer.cornerRadius = 20
        
        let date = Date(timeIntervalSince1970: Double(news.date))
        let dateString = df.string(from: date)
        
        cell.dateLabel.text = "\(dateString)"
        cell.newsTextLabel.text = news.text
        cell.nameLabel.text = groupName
        cell.avatarView.kf.setImage(with: avatarUrl)

        let superview_Width = cell.newsContentView.frame.width
        let superview_Heigh = cell.newsContentView.frame.height
        
        
        // GIF
        if news.attachments.count == 1, news.attachments[0].type == "doc" {
            guard let source = news.attachments[0].source else { return cell }
            let url = URL(string: source)
            cell.gifImg.frame = CGRect (x: 0, y: 0, width: superview_Width, height: superview_Heigh)
            
            queue.async {
                if let data = try? Data(contentsOf: url!) {
                    if let image = SDAnimatedImage (data: data) {
                        DispatchQueue.main.async {
                            cell.gifImg.image = image
                        }
                    }
                }
            }
            
            cell.newsContentView.addSubview(cell.gifImg)
            //1 Image
        } else if news.attachments.count == 1, news.attachments[0].type == "photo"{
            guard let source = news.attachments[0].source else { return cell }
            let url = URL(string: source) ?? URL (string: "")
            cell.firstImg.frame = CGRect (x: 0, y: 0, width: superview_Width, height: superview_Heigh)
            cell.firstImg.kf.setImage(with: url)
            cell.newsContentView.addSubview(cell.firstImg)
            
            // 2 Images
        } else if news.attachments.count == 2, news.attachments.allSatisfy({$0.type == "photo"}) {
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source else { return cell }
            let fUrl = URL(string: fsource)
            let sUrl = URL(string: ssource)
            cell.firstImg.frame = CGRect (x: 0, y: 0, width: superview_Width / 2, height: superview_Heigh)
            cell.secondImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: 0, width: superview_Width - cell.firstImg.frame.width , height: superview_Heigh)
            cell.firstImg.kf.setImage(with: fUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.secondImg.kf.setImage(with: sUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            
            cell.newsContentView.addSubview(cell.firstImg)
            cell.newsContentView.addSubview(cell.secondImg)
            
            //3 Images
        } else if news.attachments.count == 3, news.attachments.allSatisfy({$0.type == "photo"}){
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source, let tsource = news.attachments[2].source else { return cell }
            let fUrl = URL(string: fsource)
            let sUrl = URL(string: ssource)
            let tUrl = URL(string: tsource)
            cell.firstImg.frame = CGRect (x: 0, y: 0, width: superview_Width * 0.7, height: superview_Heigh)
            cell.secondImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: 0, width: superview_Width - cell.firstImg.frame.width , height: superview_Heigh / 2)
            cell.thirdImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: cell.secondImg.frame.maxY, width: superview_Width - cell.firstImg.frame.width, height: superview_Heigh / 2)
            
            cell.firstImg.kf.setImage(with: fUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.secondImg.kf.setImage(with: sUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.thirdImg.kf.setImage(with: tUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            
            cell.newsContentView.addSubview(cell.firstImg)
            cell.newsContentView.addSubview(cell.secondImg)
            cell.newsContentView.addSubview(cell.thirdImg)
            
            //4 Images
        } else if news.attachments.count == 4, news.attachments.allSatisfy({$0.type == "photo"}){
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source, let tsource = news.attachments[2].source, let frthsource = news.attachments[3].source else { return cell }
            let fUrl = URL(string: fsource)
            let sUrl = URL(string: ssource)
            let tUrl = URL(string: tsource)
            let frthUrl = URL(string: frthsource)
            
            cell.firstImg.frame = CGRect (x: 0, y: 0, width: superview_Width * 0.7, height: superview_Heigh)
            cell.secondImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: 0, width: superview_Width - cell.firstImg.frame.width , height: superview_Heigh / 3)
            cell.thirdImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: cell.secondImg.frame.maxY, width: superview_Width - cell.firstImg.frame.width, height: superview_Heigh / 3)
            cell.fourthImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: cell.thirdImg.frame.maxY, width: superview_Width - cell.firstImg.frame.width, height: superview_Heigh / 3)
            
            queue.async (group:dispatchGroup) {
                
            }
            
            cell.firstImg.kf.setImage(with: fUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.secondImg.kf.setImage(with: sUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.thirdImg.kf.setImage(with: tUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.fourthImg.kf.setImage(with: frthUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            
            cell.newsContentView.addSubview(cell.firstImg)
            cell.newsContentView.addSubview(cell.secondImg)
            cell.newsContentView.addSubview(cell.thirdImg)
            cell.newsContentView.addSubview(cell.fourthImg)
            
            // More than 4 images
        } else if news.attachments.count > 4, news.attachments.allSatisfy({$0.type == "photo"}){
            
            guard let fsource = news.attachments[0].source, let ssource = news.attachments[1].source, let tsource = news.attachments[2].source, let frthsource = news.attachments[3].source else { return cell }
            let fUrl = URL(string: fsource)
            let sUrl = URL(string: ssource)
            let tUrl = URL(string: tsource)
            let frthUrl = URL(string: frthsource)
            
            cell.firstImg.frame = CGRect (x: 0, y: 0, width: superview_Width * 0.7, height: superview_Heigh)
            cell.secondImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: 0, width: superview_Width - cell.firstImg.frame.width , height: superview_Heigh / 3)
            cell.thirdImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: cell.secondImg.frame.maxY, width: superview_Width - cell.firstImg.frame.width, height: superview_Heigh / 3)
            cell.fourthImg.frame = CGRect (x: cell.firstImg.frame.maxX, y: cell.thirdImg.frame.maxY, width: superview_Width - cell.firstImg.frame.width, height: superview_Heigh / 3)
            cell.countLabel.frame = cell.fourthImg.frame
            cell.fourthImg.alpha = 0.35
            cell.firstImg.kf.setImage(with: fUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.secondImg.kf.setImage(with: sUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.thirdImg.kf.setImage(with: tUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.fourthImg.kf.setImage(with: frthUrl, options: [.cacheMemoryOnly,.keepCurrentImageWhileLoading])
            cell.countLabel.text = "+\(news.attachments.count - 3)"
            
            cell.newsContentView.addSubview(cell.firstImg)
            cell.newsContentView.addSubview(cell.secondImg)
            cell.newsContentView.addSubview(cell.thirdImg)
            cell.newsContentView.addSubview(cell.fourthImg)
            cell.newsContentView.addSubview(cell.countLabel)
            
        } else {
            print ("The cell wasn't configure.\nAttach element count = \(news.attachments.count)\nNews id = \(news.id)" )
        }
        
        //        let firstImage = #imageLiteral(resourceName: "photo_2021-05-25 21.31.48")
        //        let secImg = #imageLiteral(resourceName: "photo_2021-05-25 21.31.36")
        //        let thirdImg = #imageLiteral(resourceName: "photo_2021-05-25 21.31.48")
        //        cell.firstImg.frame = CGRect (x: 0, y: 0, width: superview_Width * 0.7 - 2, height: superview_Heigh)
        //        cell.secondImg.frame = CGRect (x: cell.firstImg.frame.maxX + 2, y: 0, width: superview_Width - cell.firstImg.frame.width , height: superview_Heigh / 3 - 1)
        //        cell.thirdImg.frame = CGRect (x: cell.firstImg.frame.maxX + 2, y: cell.secondImg.frame.maxY + 2, width: superview_Width - cell.firstImg.frame.width - 1, height: superview_Heigh / 3 - 1)
        //        cell.fourthImg.frame = CGRect (x: cell.firstImg.frame.maxX + 2, y: cell.thirdImg.frame.maxY + 2, width: superview_Width - cell.firstImg.frame.width, height: superview_Heigh / 3 - 1)
        //        cell.countLabel.frame = cell.fourthImg.frame
        //        cell.firstImg.image = firstImage
        //        cell.secondImg.image = secImg
        //        cell.thirdImg.image = thirdImg
        //        cell.fourthImg.image = secImg
        //        cell.countLabel.text = "+5"
        //        cell.fourthImg.alpha = 0.35
        //        cell.newsContentView.addSubview(cell.firstImg)
        //        cell.newsContentView.addSubview(cell.secondImg)
        //        cell.newsContentView.addSubview(cell.thirdImg)
        //        cell.newsContentView.addSubview(cell.fourthImg)
        //        cell.newsContentView.addSubview(cell.countLabel)
        
        cell.likeImage.image = news.user_likes == 0 ? UIImage (systemName: "heart") : UIImage (systemName: "heart.fill")
        cell.likeCount.text = "\(news.likes)"
        cell.viewsCount.text = "\(news.views)"
        cell.repostCount.text = "\(news.reposts)"
        cell.commentCount.text = "\(news.comments)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)  {
        if let myCell = cell as? FeedTableViewCell {
            myCell.gifImg.sd_cancelCurrentImageLoad()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        token?.invalidate()
    }
}

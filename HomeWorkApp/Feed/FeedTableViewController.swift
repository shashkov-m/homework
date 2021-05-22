import UIKit
import RealmSwift
import Kingfisher
class FeedTableViewController: UITableViewController {
    let date = Date ()
    let df = DateFormatter ()
    let newsfeedRequest = NewsfeedRequest ()
    var news:Results<NewsfeedRealmEntuty>?
    let realm = try! Realm ()
    var token:NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        newsfeedRequest.getNewsfeed()
        news = realm.objects(NewsfeedRealmEntuty.self)
        df.dateFormat = "dd.MM.yyyy HH:mm"
        //        let dateString = df.string(from: date)
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
        guard let UserNews = news else {return cell}
        let news = UserNews [indexPath.row]
        let owner = realm.objects(NewsfeedRealmOwner.self).filter("id == \(news.id)")
        let avaratUrl = URL(string: owner[0].photo)
        cell.avatarView.kf.setImage(with: avaratUrl)
        cell.avatarView.layer.masksToBounds = true
        cell.avatarView.layer.cornerRadius = 20
        cell.nameLabel.text = owner[0].name
        let date = Date(timeIntervalSince1970: Double(news.date))
        let dateString = df.string(from: date)
        cell.dateLabel.text = "\(dateString)"
        cell.newsTextLabel.text = news.text
        let contentUrl = URL (string: news.attachments[0].source!)
        cell.newsContentView.kf.setImage(with: contentUrl)
        cell.newsContentView.contentMode = .scaleToFill
        
        cell.likeImage.image = news.user_likes == 0 ? UIImage (systemName: "heart") : UIImage (systemName: "heart.fill")
        cell.likeCount.text = "\(news.likes)"
        cell.viewsCount.text = "\(news.views)"
        cell.repostCount.text = "\(news.reposts)"
        cell.commentCount.text = "\(news.comments)"
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        token?.invalidate()
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

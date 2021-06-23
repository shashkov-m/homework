import UIKit
import RealmSwift
import SDWebImage
class NewsfeedTableViewController: UITableViewController {
    
    var news:Results<NewsfeedRealmEntuty>?
    var token:NotificationToken?
    let queue = DispatchQueue (label: "NewsFeedCellQueue", qos: .userInteractive, attributes: .concurrent)
    var realm = try? Realm ()
    let cache = NSCache <NSString, UIImage> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // guard let userNews = news else {return UITableViewCell ()}
        // let news = userNews [indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedTableViewCell", for: indexPath) as! NewsfeedUITableViewCell
        guard let userNews = news else {return UITableViewCell ()}
        let news = userNews [indexPath.row]
        if news.attachments.count == 1, news.attachments[0].type == "photo"{
            cell.currentIndex = indexPath.row
            return cell
        }
        return UITableViewCell ()
    }
}

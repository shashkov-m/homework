import UIKit
import RealmSwift
import Kingfisher
class CommunitiesTableViewController: UITableViewController {
    let communitiesRequest = CommunitiesRequest()
    let realm = try! Realm ()
    override func viewDidLoad() {
        super.viewDidLoad()
        communitiesRequest.getGroupsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let community = realm.objects(CommunitiesRealmEntity.self)
        return community.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCommunityCell", for: indexPath)
        let community = realm.objects(CommunitiesRealmEntity.self)[indexPath.row]
        cell.textLabel?.numberOfLines = community.type != nil ? 3 : 2
        cell.textLabel?.text = community.type != nil ? "\(community.name)\n\(community.type!)" : community.name
        cell.textLabel?.font = .systemFont(ofSize: 13)
        let url = URL (string: community.photo)
        cell.imageView?.kf.setImage(with: url)
        cell.imageView?.layer.cornerRadius = 25
        cell.imageView?.layer.masksToBounds = true
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

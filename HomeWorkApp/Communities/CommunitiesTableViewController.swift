import UIKit
import RealmSwift
import Kingfisher
class CommunitiesTableViewController: UITableViewController {
    let communitiesRequest = CommunitiesRequest()
    let realm = try! Realm ()
    var community:Results<CommunitiesRealmEntity>?
    var token:NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        communitiesRequest.getGroupsList()
        community = realm.objects(CommunitiesRealmEntity.self)
        token = community?.observe { [weak self] changes in
            switch changes {
            case .initial(_):
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return community?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCommunityCell", for: indexPath)
        guard let communities = community else {return cell}
        let community = communities [indexPath.row]
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
    
    deinit {
        token?.invalidate()
    }
}

import UIKit
import RealmSwift
class CommunitiesTableViewController: UITableViewController {
    private let communitiesRequest = CommunitiesRequest()
    private var realm = try? Realm ()
    private var community:Results<CommunitiesRealmEntity>?
    private var token:NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        communitiesRequest.getGroupsList()
        community = realm?.objects(CommunitiesRealmEntity.self)
        tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
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
        tableView.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return community?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsTableViewCell
        guard let communities = community else {return cell}
        let community = communities [indexPath.row]
        cell.nameLabel.text = "\(community.name)"
        cell.cityLabel.text = "\(community.type ?? "")"
        let url = URL (string: community.photo)
        cell.avatarView.sd_setImage(with: url)
        return cell
    }
    
    deinit {
        token?.invalidate()
    }
}

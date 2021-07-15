////  Created by Шашков Максим Алексеевич on 02.03.2021.
////
import UIKit
import RealmSwift
import SDWebImage

class FriendsTableViewController: UITableViewController {
    
    private let friendsRequest = FriendsRequest()
    private let albumRequest = AlbumRequest()
    private var user_id:Int = 0
    private let realm = try! Realm ()
    private var friends:Results<FriendsRealmEntity>?
    private var token :NotificationToken?
    private let date = Date ()
    private let df = DateFormatter ()

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsRequest.getFriendsList()
        friends = realm.objects(FriendsRealmEntity.self)
        tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsCell")
        
        token = friends?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                print ("update data")
                self?.tableView.reloadData()
            case .error(let error):
                print (error.localizedDescription)
            }
        }

        print("Realm path = \(String(describing: realm.configuration.fileURL))")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsTableViewCell
        guard let friends = friends else { return cell }
        let user = friends [indexPath.row]
        cell.nameLabel.text = "\(user.name)"
        if let city = user.city {
            cell.cityLabel.text = "\(city)"
        }
        let url = URL(string: user.photo)
        cell.avatarView.sd_setImage (with: url, placeholderImage: nil)
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let friends = friends else { return }
        let user = friends [indexPath.row]
        user_id = user.id
        performSegue(withIdentifier: "toAlbums", sender: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbums",
           let albumsVC = segue.destination as? AlbumsCollectionViewController {
            albumsVC.user_id = user_id
        }
    }

    deinit {
        token?.invalidate()
    }
}


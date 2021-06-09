//
//  SearchViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 02.03.2021.
//
import UIKit
import RealmSwift
import SDWebImage
import FirebaseFirestore
class FriendsTableViewController: UITableViewController {
    
    let friendsRequest = FriendsRequest()
    let albumRequest = AlbumRequest()
    var user_id:Int = 0
    let realm = try! Realm ()
    var friends:Results<FriendsRealmEntity>?
    var token :NotificationToken?
    let firestore = Firestore.firestore()
    let date = Date ()
    let df = DateFormatter ()
    
    @IBAction func reloadButton(_ sender: Any) {
        friendsRequest.getFriendsList()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsRequest.getFriendsList()
        friends = realm.objects(FriendsRealmEntity.self)
        print("Realm path = \(String(describing: realm.configuration.fileURL))")
        token = friends?.observe {[weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.tableView.reloadData()
            case .error(let error):
                print (error.localizedDescription)
            }
        }
        df.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateString = df.string(from: date)
        firestore.collection("users").document(Session.session.userId).setData(["last auth":"\(dateString)"]) { error in
            if let error = error {
                print ("firestore error: \(error)")
            } else {
                print ("firestore success")
            }
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)
        guard let friends = friends else {return cell}
        let user = friends [indexPath.row] //sortedUserDictionary[indexPath.section].value [indexPath.row]
        //        let paragraphStyle = NSMutableParagraphStyle()
        //       paragraphStyle.firstLineHeadIndent = 55
        //       let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        cell.textLabel?.numberOfLines = user.city != "" ? 2 : 1
        let text = user.city != "" ? "\(user.name)\n\(user.city!)" : "\(user.name)"
        cell.textLabel?.text = text
        let url = URL(string: user.photo)
        cell.imageView?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_2021-05-25 21.31.48"))
        cell.imageView?.layer.cornerRadius = 25
        cell.imageView?.layer.masksToBounds = true
        //       cell.textLabel?.attributedText = NSAttributedString (string: text, attributes: attributes)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = friends![indexPath.row]
        user_id = user.id
        performSegue(withIdentifier: "toAlbums", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
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

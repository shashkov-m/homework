import UIKit
import RealmSwift
import Kingfisher
class PhotoViewController: UIViewController {
    @IBOutlet weak var photoView: UIImageView!
    var user_id:Int = 0
    var album_id:Int = 0
    var selectedPhoto:Int = 0
    let realm = try! Realm()
    var photosList:Results<PhotoRealmEntity>?
    override func viewDidLoad() {
        super.viewDidLoad()
        photosList = realm.objects(PhotoRealmEntity.self).filter("album_id == \(album_id) AND owner_id == \(user_id)")
        guard let photosList = photosList else { return }
        let url = URL(string: photosList[selectedPhoto].photo)
        photoView.kf.setImage(with: url)
        let rightSwipe = UISwipeGestureRecognizer (target: self, action: #selector(moveToNextItem(_:)))
        let leftSwipe = UISwipeGestureRecognizer (target: self, action: #selector(moveToNextItem(_:)))
        rightSwipe.direction = .right
        leftSwipe.direction = .left
        rightSwipe.numberOfTouchesRequired = 1
        leftSwipe.numberOfTouchesRequired = 1
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    var animateIsActive:Bool = false
    
    @objc private func moveToNextItem (_ sender: UISwipeGestureRecognizer) {
        //let photosList = realm.objects(PhotoRealmEntity.self).filter("album_id == \(album_id) AND owner_id == \(user_id)")
        switch sender.direction {
        
        case .left:
            
            guard let photosList = photosList, selectedPhoto < photosList.count - 1 && !animateIsActive else { return }
            animateIsActive = true
            selectedPhoto += 1
            let newImage = UIImageView ()
            newImage.frame = CGRect (x: photoView.layer.frame.origin.x + 420, y: photoView.layer.frame.origin.y, width: photoView.frame.width, height: photoView.frame.height)
            newImage.contentMode = .scaleAspectFit
            let url = URL(string: photosList[selectedPhoto].photo)
            newImage.kf.setImage(with: url)
            view.addSubview(newImage)
            UIView.animate(withDuration: 0.8, delay: 0, options:.transitionCrossDissolve, animations: {
                self.photoView.transform = CGAffineTransform (translationX: -420, y: 0)
                newImage.transform = CGAffineTransform (translationX: -420, y: 0)
            }, completion: {finished in
                self.photoView.transform = .identity
                self.photoView.kf.setImage(with: url)
                newImage.removeFromSuperview()
                self.animateIsActive = false
            })
            
        case .right:
            guard let photosList = photosList, selectedPhoto > 0 && !animateIsActive else { return }
            animateIsActive = true
            selectedPhoto -= 1
            let newImage = UIImageView ()
            newImage.frame = CGRect (x: photoView.layer.frame.origin.x - 420, y: photoView.layer.frame.origin.y, width: photoView.frame.width, height: photoView.frame.height)
            newImage.contentMode = .scaleAspectFit
            let url = URL(string: photosList[selectedPhoto].photo)
            newImage.kf.setImage(with: url)
            view.addSubview(newImage)
            UIView.animate(withDuration: 0.8, delay: 0, options:.transitionCrossDissolve, animations: {

                newImage.transform = CGAffineTransform (translationX: 420, y: 0)
                self.photoView.transform = CGAffineTransform (translationX: 420, y: 0)
            
            }, completion: {finished in
                self.photoView.transform = .identity
                self.photoView.kf.setImage(with: url)
                newImage.removeFromSuperview()
                self.animateIsActive = false
            })
        default:
            break
        }
    }
    
}

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var photoView: UIImageView!
    var photosList:[AlbumRequest.Photos] = []
    var selectedPhoto:Int = 0
    var album_id:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let photo = photosList.filter {$0.album_id == album_id}
        let image = photo [selectedPhoto].photo
        photoView.image = image
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
        switch sender.direction {
        
        case .left:
            let photo = photosList.filter {$0.album_id == album_id}
            guard selectedPhoto < photo.count - 1 && !animateIsActive else { return }
            animateIsActive = true
            selectedPhoto += 1
            let image = photo [selectedPhoto].photo
            let newImage = UIImageView ()
            newImage.frame = CGRect (x: photoView.layer.frame.origin.x + 420, y: photoView.layer.frame.origin.y, width: photoView.frame.width, height: photoView.frame.height)
            newImage.contentMode = .scaleAspectFit
            newImage.image = image
            view.addSubview(newImage)
            UIView.animate(withDuration: 0.8, delay: 0, options:.transitionCrossDissolve, animations: {
                self.photoView.transform = CGAffineTransform (translationX: -420, y: 0)
                newImage.transform = CGAffineTransform (translationX: -420, y: 0)
            }, completion: {finished in
                self.photoView.transform = .identity
                self.photoView.image = image
                newImage.removeFromSuperview()
                self.animateIsActive = false
            })
            
        case .right:
            let photo = photosList.filter {$0.album_id == album_id}
            guard selectedPhoto > 0 && !animateIsActive else { return }
            animateIsActive = true
            selectedPhoto -= 1
            let image = photo [selectedPhoto].photo
            let newImage = UIImageView ()
            newImage.frame = CGRect (x: photoView.layer.frame.origin.x - 420, y: photoView.layer.frame.origin.y, width: photoView.frame.width, height: photoView.frame.height)
            newImage.contentMode = .scaleAspectFit
            newImage.image = image
            view.addSubview(newImage)
            UIView.animate(withDuration: 0.8, delay: 0, options:.transitionCrossDissolve, animations: {

                newImage.transform = CGAffineTransform (translationX: 420, y: 0)
                self.photoView.transform = CGAffineTransform (translationX: 420, y: 0)
            
            }, completion: {finished in
                self.photoView.transform = .identity
                self.photoView.image = image
                newImage.removeFromSuperview()
                self.animateIsActive = false
            })
        default:
            break
        }
    }
    
}

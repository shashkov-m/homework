//
//  PhotoViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 30.03.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var photoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let photoNumber = selectedPhoto
        let image = userPhotos [photoNumber]
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
            guard selectedPhoto < userPhotos.count - 1 && !animateIsActive else { return }
            animateIsActive = true
            selectedPhoto += 1
            let image = userPhotos [selectedPhoto]
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
            guard selectedPhoto > 0 && !animateIsActive else { return }
            animateIsActive = true
            selectedPhoto -= 1
            let image = userPhotos [selectedPhoto]
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

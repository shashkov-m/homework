//
//  CustomControl.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 26.03.2021.
//

import UIKit

class CustomControl: UIControl {
    var likeCount:Int = 110 {
        didSet {
            countLabel.text = "\(likeCount)"
        }
    }
    var isLikePressed:Bool = false {
        didSet {
            updateLikeImage ()
        }
    }
    var likeImage:UIImage? = nil {
        didSet {
            likeImageView.image = likeImage
        }
    }
    private var stack:UIStackView!
    private var countLabel:UILabel!
    private var likeImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.frame = bounds
    }
    private func customInit () {
        countLabel = UILabel ()
        likeImageView = UIImageView ()
        likeImageView.contentMode = .scaleAspectFit
        countLabel.textAlignment = .left
        stack = UIStackView (arrangedSubviews: [likeImageView, countLabel])
        addSubview(stack)
        stack.spacing = 0
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        countLabel.text = "\(likeCount)"
        updateLikeImage ()
    }
    private func updateLikeImage () {
        if isLikePressed {
            likeImage = UIImage (systemName: "heart.fill")
            likeImageView.tintColor = .red
            likeCount += 1
        } else {
            likeImage = UIImage (systemName: "heart")
            likeImageView.tintColor = .gray
            guard likeCount > 0 else { return }
            likeCount -= 1
            
        }

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isLikePressed.toggle()
        sendActions(for: .valueChanged)
    }

}

////
////  ViewWithShadow.swift
////  HomeWorkApp
////
////  Created by Шашков Максим Алексеевич on 18.03.2021.
////
//
//import UIKit
//
// class ViewWithShadow: UIView {
//    @IBInspectable var shadowColor:UIColor = .black {
//        didSet {
//            layer.shadowColor = shadowColor.cgColor
//            //            layer.shadowColor = shadowColor
//        }
//    }
//
//    @IBInspectable var shadowOpacity: Float = 0.7{
//        didSet {
//            layer.shadowOpacity = shadowOpacity
//        }
//    }
//
//    @IBInspectable var shadowRadius:CGFloat = 8 {
//        didSet {
//            layer.shadowRadius = shadowRadius
//        }
//    }
//
//    @IBInspectable var shadowOffset: CGSize = .zero {
//        didSet {
//            layer.shadowOffset = shadowOffset
//        }
//    }
//
//    @IBInspectable var image: UIImage? = nil {
//        didSet {
//            imageView.image = image
//            setNeedsDisplay()
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            imageView.layer.masksToBounds = cornerRadius > 0
//            imageView.layer.cornerRadius = cornerRadius
//        }
//    }
//
//    var imageView = UIImageView()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//
//    func commonInit() {
//        addSubview(imageView)
//        imageView.contentMode = .scaleAspectFill
//        backgroundColor = .clear
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageView.frame = bounds
//    }
//
//}

//
//  ViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 27.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        letterCount()
    }
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "logOut",
           let _ = unwindSegue.source as? FriendsTableViewController{
            loginField.text = nil
            passwordField.text = nil
            enterButton.isEnabled = true
        }
    }
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func enter(_ sender: Any) {
        let login:String = loginField.text!
        let password:String = passwordField.text!
        guard login != "" else {return}
        guard password != "" else {return}
        enterButton.isEnabled = false
        dotsAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.replicatorLayer.removeFromSuperlayer()
            self.performSegue(withIdentifier: "SegueTabBar", sender: nil)
            
        }
    }
    
    @IBAction func eyeToggle(_ sender: Any) {
        passwordField.isSecureTextEntry.toggle()
    }
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private let replicatorLayer = CAReplicatorLayer ()
    private func dotsAnimation () {
        // replicatorLayer.frame = CGRect (x: 180, y: 215, width: 15, height: 7)
        replicatorLayer.frame = CGRect(x: scrollView.center.x - 12 /*enterButton.frame.minX*/, y: enterButton.frame.minY - 10, width: 15, height: 7)
        let dot = CALayer ()
        dot.frame = CGRect(x: 0, y: 0, width: 7, height: 7)
        dot.cornerRadius = dot.frame.width / 2
        dot.backgroundColor = UIColor.black.cgColor
        replicatorLayer.addSublayer(dot)
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0)
        //replicatorLayer.instanceTransform = CATransform3DRotate(CATransform3D(), 90, 0, 0, 0)
        let anim = CABasicAnimation (keyPath: "opacity")
        anim.fromValue = 1
        anim.toValue = 0.3
        anim.duration = 1
        anim.repeatCount = .infinity
        anim.fillMode = .removed
        dot.add(anim, forKey: nil)
        replicatorLayer.instanceDelay = anim.duration / Double(replicatorLayer.instanceCount)
        scrollView.layer.addSublayer(replicatorLayer)
    }
    
}


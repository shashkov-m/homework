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
        // Do any additional setup after loading the view.

    }
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBAction func onClickListener(_ sender: Any) {
        let login:String = loginField.text!
        let password:String = passwordField.text!
        guard login != "" else {return}
        guard password != "" else {return}
        
        //LOG
        NSLog("Login: \(login) Password: \(password)")
        
        //Alert message
        let alert = UIAlertController(title: "Alert", message: "Login: \(login)\nPassword: \(password)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
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
}


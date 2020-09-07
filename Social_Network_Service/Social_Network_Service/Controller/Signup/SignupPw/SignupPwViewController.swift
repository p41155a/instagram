//
//  SignupPwViewController.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/29.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class SignupPwViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var email: String?
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        if (passwordTextField.text == "" || passwordTextField.text == nil) {
            let alert = UIAlertController(title: "입력해주세요", message: "입력값이 없습니다.", preferredStyle: UIAlertController.Style.alert )
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            let apiManager = UserAPIManager()
            apiManager.join(email: email ?? "", password: passwordTextField.text ?? "", username: username ?? "", completion: {
                print("login success")
                
                let viewControllers : [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 5 ], animated: false)
            }) { message in
                print("login fail")
                
                let alert = UIAlertController(title: "회원가입에 실패하였습니다", message: message, preferredStyle: UIAlertController.Style.alert )
                let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
                
                return
            }
            
        }
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        let viewControllers : [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 5 ], animated: false)
    }
}

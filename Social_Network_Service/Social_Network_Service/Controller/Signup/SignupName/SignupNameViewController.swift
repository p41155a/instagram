//
//  SignupNameViewController.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/29.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class SignupNameViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        if (nameTextField.text == "" || nameTextField.text == nil) {
            let alert = UIAlertController(title: "입력해주세요", message: "입력값이 없습니다.", preferredStyle: UIAlertController.Style.alert )
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "SignupPwViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "SignupPwViewController") as SignupPwViewController
            vc.email = email
            vc.username = nameTextField.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        let viewControllers : [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 4 ], animated: false)
    }
}

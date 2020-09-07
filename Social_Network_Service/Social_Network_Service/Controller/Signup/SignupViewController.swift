//
//  SignupViewController.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/26.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signupButtonClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignupIDViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SignupIDViewController")
        vc.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func loginButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  EmailView.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/26.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class EmailView: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func nextButtonClick(_ sender: Any) {
        if (emailTextField.text == "" || emailTextField.text == nil) {
            let alert = UIAlertController(title: "입력해주세요", message: "입력값이 없습니다.", preferredStyle: UIAlertController.Style.alert )
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "SignupNameViewController", bundle: nil)

            let vc = storyboard.instantiateViewController(identifier: "SignupNameViewController") as SignupNameViewController
            vc.email = emailTextField.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

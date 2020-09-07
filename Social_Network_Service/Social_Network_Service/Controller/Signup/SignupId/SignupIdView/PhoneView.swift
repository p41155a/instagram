//
//  PhoneView.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/26.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class PhoneView: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    
    // 정규식 추가 예정
    @IBAction func nextButtonClick(_ sender: Any) {
        if (phoneTextField.text == "" || phoneTextField.text == nil) {
            let alert = UIAlertController(title: "입력해주세요", message: "입력값이 없습니다.", preferredStyle: UIAlertController.Style.alert )
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "SignupNameViewController", bundle: nil)

            let vc = storyboard.instantiateViewController(identifier: "SignupNameViewController") as SignupNameViewController
            vc.email = phoneTextField.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//
//  ViewController.swift
//  Social_Network_Service
//
//  Created by 이주영 on 2020/06/19.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var orTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var orBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        idTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        idTextField.addTarget(self, action: #selector(textFieldEndEditing), for: .editingDidEnd)
        pwTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        pwTextField.addTarget(self, action: #selector(textFieldEndEditing), for: .editingDidEnd)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // textfield 밖의 공간 클릭 시 키보드 들어감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    func setView() {
        idTextField.layer.cornerRadius = 6
        pwTextField.layer.cornerRadius = 6
        loginButton.layer.cornerRadius = 6
        facebookLoginButton.layer.cornerRadius = 6
    }
    
    @objc func textFieldBeginEditing() {
        UIView.animate(withDuration: 0.25) {
            self.logoTopConstraint.constant = 0
            self.logoBottomConstraint.constant = 0
            self.loginButtonTopConstraint.constant = 12
            self.orTopConstraint.constant = 20
            self.orBottomConstraint.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    @objc func textFieldEndEditing() {
        UIView.animate(withDuration: 0.25) {
            self.logoTopConstraint.constant = 50
            self.logoBottomConstraint.constant = 40
            self.loginButtonTopConstraint.constant = 24
            self.orTopConstraint.constant = 34
            self.orBottomConstraint.constant = 34
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        
        guard let id = idTextField.text, let pw = pwTextField.text else {
            return
        }
        
        if id == "" || pw == "" {
            let alert = UIAlertController(title: "입력해주세요", message: "입력값이 없습니다.", preferredStyle: UIAlertController.Style.alert )
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            return
        }
        
        let apiManager = UserAPIManager()
        apiManager.login(email: id, password: pw, completion: {
            print("login success")
//            let feedAPIManager = FeedAPIManager()
//            feedAPIManager.feed(completion: {
            
            
                let storyboard = UIStoryboard(name: "HomeViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController")
                
                vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                self.navigationController?.pushViewController(vc, animated: true)
            
            
//            }, failure: { message in
//                let alert = UIAlertController(title: "피드 로드에 실패하였습니다", message: message, preferredStyle: UIAlertController.Style.alert )
//                let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
//                alert.addAction(okAction)
//                self.present(alert, animated: false, completion: nil)
//            })
        }) { message in
            print("login fail")
            
            let alert = UIAlertController(title: "로그인에 실패하였습니다", message: message, preferredStyle: UIAlertController.Style.alert )
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            alert.addAction(okAction)
            self.present(alert, animated: false, completion: nil)
            
            return
        }
    }
    @IBAction func faceBookLoginButtonClick(_ sender: Any) {
    }
    @IBAction func SignupButtonClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignupViewController", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupViewController")
        
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//
//  SignupIDViewController.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/26.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class SignupIDViewController: UIViewController {
    
    @IBOutlet weak var SignIDView: UIView!
    @IBOutlet weak var phoneUnderView: UIView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailUnderView: UIView!
    @IBOutlet weak var emailButton: UIButton!
    
    var scrollView: UIScrollView!
    
    var phoneView: UIView = UIView()
    var emailView: UIView = UIView()
    
    lazy var contentsViewList: [UIView] = [phoneView, emailView]
    
    let phoneVC = PhoneView()
    let emailVC = EmailView()
   
    lazy var contentsVCList: [UIViewController] = [phoneVC, emailVC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setScrollView() {
        let width = UIScreen.main.bounds.size.width
        let height = SignIDView.frame.height
        
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        
        SignIDView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { maker in
            maker.leading.equalTo(SignIDView.snp.leading)
            maker.trailing.equalTo(SignIDView.snp.trailing)
            maker.top.equalTo(SignIDView.snp.top)
            maker.bottom.equalTo(SignIDView.snp.bottom)
        }
        
        setContentsScrollView(width, height)
        setContentsVC(width, height)
    }
    
    func setContentsScrollView(_ width: CGFloat, _ height: CGFloat) {
        for i in 0..<contentsViewList.count {
            let view = contentsViewList[i]
            view.backgroundColor = .clear
            view.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
            
            scrollView.addSubview(view)
        }
        
        scrollView.contentSize.width = width * CGFloat(contentsViewList.count)
        scrollView.contentSize.height = height
    }
    
    func setContentsVC(_ width: CGFloat, _ height: CGFloat) {
        for i in 0..<contentsVCList.count {
            let vc = contentsVCList[i]

            self.addChild(vc)
            self.contentsViewList[i].addSubview(vc.view)

            vc.view.snp.makeConstraints { maker in
                maker.trailing.equalToSuperview()
                maker.leading.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
                maker.width.equalTo(width)
                maker.height.equalTo(height)
            }
        }
    }
    @IBAction func phoneButtonClick(_ sender: Any) {
        self.scrollView.contentOffset.x = UIScreen.main.bounds.size.width * 0
        phoneUnderView.backgroundColor = .black
        emailUnderView.backgroundColor = .systemGray2
    }
    @IBAction func emailButtonClick(_ sender: Any) {
        self.scrollView.contentOffset.x = UIScreen.main.bounds.size.width * 1
        phoneUnderView.backgroundColor = .systemGray2
        emailUnderView.backgroundColor = .black
    }
    
    @IBAction func loginButtonClick(_ sender: Any) {
        let viewControllers : [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3 ], animated: false)
    }
}

extension SignupIDViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.x == UIScreen.main.bounds.size.width * 0) {
            phoneUnderView.backgroundColor = .black
            emailUnderView.backgroundColor = .systemGray2
        } else if(scrollView.contentOffset.x == UIScreen.main.bounds.size.width * 1) {
            phoneUnderView.backgroundColor = .systemGray2
            emailUnderView.backgroundColor = .black
        }
    }
}



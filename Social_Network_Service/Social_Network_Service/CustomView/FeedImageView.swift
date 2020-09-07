//
//  FeedImageView.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/26.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

protocol FeedImageViewDelegate: class {
    func tapImage(imageView: UIImageView, index: Int)
    func setPageControl(index: Int)
}

class FeedImageView: UIView {
    var scrollView: UIScrollView!
    var imageViews: [UIImageView] = []
    var pageView: UIView?
    var pageLabel: UILabel?
    
    var imageUrls: [String] = [] {
        didSet{
            addImageView()
        }
    }
    
    var imageContentMode: UIView.ContentMode = .scaleAspectFill
    
    var placeholderImage: UIImage = #imageLiteral(resourceName: "profileImage.png")
    
    weak var delegate: FeedImageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setInitView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setInitView()
    }
    
    // 스크롤 뷰 올림
    private func setInitView() {
        
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    // 스크롤 뷰 안에 이미지, 페이지뷰를 넣음
    private func addImageView() {
        
        if imageViews.count != 0 {
            return
        }
        
        let width = UIScreen.main.bounds.width
        
        for i in 0..<imageUrls.count {
            let imageView = UIImageView()
            imageView.contentMode = imageContentMode
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: width)
            imageView.image = placeholderImage
            
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
            
        }
        
        scrollView.contentSize.width = width * CGFloat(imageUrls.count)
        scrollView.contentSize.height = width
        
        downloadImages()
        showMessageView()
        
        pageView = UIView()
        
        self.addSubview(pageView ?? UIView.init())
        
        pageView?.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().offset(-20)
            maker.top.equalToSuperview().offset(20)
            maker.height.equalTo(20)
            maker.width.equalTo(40)
        }
        
        pageView?.backgroundColor = .black
        pageView?.layer.cornerRadius = 10
        pageView?.clipsToBounds = true
        
        pageLabel = UILabel()
        pageLabel?.text = "1 / \(imageUrls.count)"
        pageLabel?.textColor = .white
        pageLabel?.font = UIFont.systemFont(ofSize: CGFloat(13))
        
        pageView?.addSubview(pageLabel ?? UILabel.init())
        
        pageLabel?.snp.makeConstraints { maker in
            maker.centerY.equalTo(pageView!)
            maker.centerX.equalTo(pageView!)
        }
        
        pageView?.isHidden = true
    }
    
    // 이미지뷰에 이미지 다운 받아 넣음
    private func downloadImages() {
        for i in 0..<imageUrls.count {
            let urlStr = imageUrls[i]

            if let url = URL(string: urlStr) {
                imageViews[i].kf.setImage(with: url, options: [.transition(.fade(0.3)), .forceTransition, .keepCurrentImageWhileLoading])
            }
        }
    }
    
    // 페이지뷰 애니메이션 설정
    private func showMessageView() {
        pageView?.alpha = 0
        pageView?.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pageView?.alpha = 0.5
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.pageView?.alpha = 0.5
                }) { _ in
                    self.pageView?.isHidden = true
                    self.pageView?.alpha = 1
                }
            }
        }
    }
    
    @objc func tapImageView(_ sender: UITapGestureRecognizer) {
        // index: 저장된 이미지 배열에서 tap된 이미지가 있는 첫 인덱스
        if let imageView = sender.view as? UIImageView, let index = imageViews.firstIndex(of: imageView) {
            delegate?.tapImage(imageView: imageView, index: index)
        }
    }
}
extension FeedImageView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageLabel?.text = "\(index+1) / \(self.imageUrls.count)"
        delegate?.setPageControl(index: index)
    }
}

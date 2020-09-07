//
//  imageDetailViewer.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/20.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class ImageDetailViewer: UIView {
    
    // 검은색 배경뷰
    lazy private var blackBackgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor.black
        
        return view
    }()
    
    // 이미지 페이징 스크롤 뷰
    lazy private var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        return scrollView
    }()
    
    // 종료 버튼
    lazy private var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        
        // 버튼 액션
        button.addTarget(self, action: #selector(closeButtonAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var scrollViews: [UIScrollView] = []
    var imageViews: [UIImageView] = []
    var loadingViews: [UIView] = []
    var loadingLayers: [CAShapeLayer] = []
    var panGestures: [UIPanGestureRecognizer] = []
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // 자식클래스에서 이니셜라이저를 작성하게되면, 부모 클래스의 이니셜라이저들이 자동으로 상속 되지 않아 이니셜라이저 필요
    public required  init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(parentView: UIView) {
        super.init(frame: parentView.bounds)
        
        setUI(parentView: parentView)
    }
    
    // 이미지 이동 제스처
    @objc private func moveImageAction(_ sender: UIPanGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        
        let translation = sender.translation(in: self)
        
        switch sender.state {
        case .began:
            break
        case .changed:
            imageView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
            let y = translation.y > 0 ? translation.y : (-1 * translation.y)
            blackBackgroundView.alpha = 1.0 - (y / (self.frame.height / 2))
        case .ended:
            if blackBackgroundView.alpha < 0.7 {
                hide(imageView: imageView)
            } else {
                UIView.animate(withDuration: 0.2) { [weak self] in
                    imageView.transform = .identity
                    self?.blackBackgroundView.alpha = 1
                }
            }
        default:
            break
        }
    }
    
    // 더블 탭 시 이미지 줌 인/아웃
    @objc private func zoomImageAction(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView, let index = imageViews.firstIndex(of: imageView) else {
            return
        }
        
//        print("전체 이미지 개수: \(scrollViews.count), 현재 탭 위치: \(index+1)")
        
        let scrollView = scrollViews[index]
        
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.zoomScale = scrollView.zoomScale == 1.0 ? 4.0 : 1.0
        }) { _ in
            self.panGestures[index].isEnabled = scrollView.zoomScale == 1.0 ? true : false
        }
    }
    
    // 종료 버튼 클릭 이벤트
    @objc private func closeButtonAction(sender: UIButton) {
        let index = Int(round(self.scrollView.contentOffset.x / self.scrollView.frame.width))
        hide(imageView: imageViews[index])
    }
}

// 실제 그리는 소스
extension ImageDetailViewer {
    private func setUI(parentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false // 위치 설정을 위한 필수 코드
        backgroundColor = .clear
        isHidden = true
        
        // 최상위 뷰 컨트롤러에 뷰 올림
        if #available(iOS 13, *) {
            UIApplication.shared.windows.first { $0.isKeyWindow }?.addSubview(self)
        } else {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        
        self.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        // 검은색 배경 뷰 세팅
        addSubview(blackBackgroundView)
        blackBackgroundView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.equalToSuperview()
        }
        
        // 이미지 줌 스크롤을 위한 스크롤 뷰 세팅
        addSubview(scrollView)
        scrollView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.leading.equalToSuperview()
        }
        
        addSubview(closeButton)
        closeButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.snp.topMargin)
            maker.leading.equalToSuperview().offset(16)
            maker.width.height.equalTo(25)
        }
    }
    
    func setImage(imagePaths: [String]) {
        for i in 0..<imagePaths.count {
            
            // 이미지 Zoom, Move를 위한 스크롤 뷰
            let scrollView = UIScrollView()
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 4.0
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.bounces = false
            scrollView.zoomScale = 1.0
            scrollView.delegate = self
            scrollView.frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
            
            self.scrollView.addSubview(scrollView)
            
            scrollViews.append(scrollView)
            
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
            // 이미지 뷰 이동 제스처
            let panGesture = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(moveImageAction(_:)))
            imageView.addGestureRecognizer(panGesture)
            
            panGestures.append(panGesture)
            
            // 이미지 뷰 더블 탭 제스처
            let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomImageAction(_:)))
            doubleTapGesture.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(doubleTapGesture)
            
            scrollView.addSubview(imageView)
            
            imageViews.append(imageView)
            
            let loadingView = UIView()
            loadingView.backgroundColor = .lightGray
            loadingView.frame = CGRect(x: (self.frame.width / 2) - 25, y: (self.frame.height / 2) - 25, width: 50, height: 50)
            loadingView.isHidden = true
            
            scrollView.addSubview(loadingView)
            loadingViews.append(loadingView)
            
            loadingView.layer.cornerRadius = 16
            
            let path = UIBezierPath(arcCenter: CGPoint(x: loadingView.frame.width / 2, y: loadingView.frame.height / 2), radius: 15, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = UIColor.white.cgColor
            layer.strokeStart = 0
            layer.strokeEnd = 0
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = 3
            
            loadingView.layer.addSublayer(layer)
            loadingLayers.append(layer)
            
            let urlStr = imagePaths[i]

            if let url = URL(string: urlStr) {
                imageView.kf.setImage(with: url, options: [.transition(.fade(0.3)), .forceTransition, .keepCurrentImageWhileLoading])
            }
        }
        
        self.scrollView.contentSize.width = self.frame.width * CGFloat(imagePaths.count)
        self.scrollView.contentSize.height = self.frame.height
    }
    
    // 이미지 상세보기 열기
    public func show(originImageView: UIImageView?, index: Int)  {
        if let imageView = originImageView, let startingFrame = imageView.superview?.convert(imageView.frame, to: nil) {
            
            isHidden = false
            
            imageView.alpha = 0
            
            imageViews[index].frame = startingFrame
            
            blackBackgroundView.alpha = 0
            
            scrollView.contentOffset.x = self.frame.width * CGFloat(index)
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let frame = self?.frame {
                    self?.imageViews[index].frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                    self?.blackBackgroundView.alpha = 1
                }
            }) { _ in
                imageView.alpha = 1
            }
        }
    }
    
    // 이미지 상세보기 닫기
    private func hide(imageView: UIImageView) {
        // 종료 후 컨트롤 설정
        func closeComplete() {
            blackBackgroundView.alpha = 1
            imageView.transform = .identity
            isHidden = true
            
            scrollViews.forEach { scrollView in
                scrollView.removeFromSuperview()
            }
            scrollViews.removeAll()
            
            imageViews.forEach { imageView in
                imageView.removeFromSuperview()
            }
            imageViews.removeAll()

            panGestures.removeAll()
            
        }
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blackBackgroundView.alpha = 0
            imageView.alpha = 0
        }) { _ in
            closeComplete()
        }
    }
}

extension ImageDetailViewer: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        guard let index = scrollViews.firstIndex(of: scrollView) else {
            return nil
        }
        
        return imageViews[index]
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let index = scrollViews.firstIndex(of: scrollView) else {
            return
        }
        
        let imageView = imageViews[index]
        
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight * scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let index = scrollViews.firstIndex(of: scrollView) else {
            return
        }
        
        panGestures[index].isEnabled = scale == 1.0 ? true : false
    }
}

//
//  feedTableViewCell.swift
//  instagram
//
//  Created by Yoojin Park on 2020/06/14.
//  Copyright © 2020 Yoojin Park. All rights reserved.
//

import UIKit
import SnapKit

protocol feedTableViewCellDelegate: class {
    func tapImage(imageView: UIImageView, index: Int)
}
class feedTableViewCell: UITableViewCell{
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var commentButton: CommentButton!
    @IBOutlet weak var feedImageView: FeedImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate: feedTableViewCellDelegate?
    
    var imageUrls: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileView.layer.cornerRadius = profileView.frame.height/2
        profileView.clipsToBounds = true
        
        feedImageView.imageUrls = imageUrls
        feedImageView.delegate = self
    }
    
    func setImagesCell(imageUrls: [String]) {
        self.imageUrls = imageUrls
        self.pageControl.numberOfPages = imageUrls.count
    }
}

// 댓글버튼
class CommentButton: UIButton {
    var myTitleImage: UIImageView!
    var buttonTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setButtonInit()
    }
    
    private func setButtonInit() {
        myTitleImage = UIImageView()
        myTitleImage.image = #imageLiteral(resourceName: "profileImage.png")
        
        addSubview(myTitleImage)
        myTitleImage.snp.makeConstraints { maker in
            maker.leading.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(24)
            maker.height.equalTo(24)
        }
        myTitleImage.layer.cornerRadius = 12
        myTitleImage.layer.masksToBounds = true
        
        buttonTitle = UILabel()
        buttonTitle.text = "댓글 달기..."
        
        addSubview(buttonTitle)
        buttonTitle.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(myTitleImage.snp.trailing).offset(5)
        }
    }
}

extension feedTableViewCell: FeedImageViewDelegate {
    func tapImage(imageView: UIImageView, index: Int) {
        delegate?.tapImage(imageView: imageView, index: index)
    }
    
    func setPageControl(index: Int) {
        pageControl.currentPage = index
    }
}

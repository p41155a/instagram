//
//  HomeViewController.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/06/24.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var imageDetailViewer: ImageDetailViewer!
    
    let feedCell = [feedTableViewCell.self]

    let imageUrls = [
        "https://raw.githubusercontent.com/swieeft/JSON/master/CardNews1Thumbnail.png",
        "https://raw.githubusercontent.com/swieeft/JSON/master/CardNews2Thumbnail.png",
        "https://raw.githubusercontent.com/swieeft/JSON/master/CardNews3Thumbnail.png",
        "https://raw.githubusercontent.com/swieeft/JSON/master/CardNews4Thumbnail.png",
        "https://raw.githubusercontent.com/swieeft/JSON/master/CardNews5Thumbnail.png"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDetailViewer = ImageDetailViewer(parentView: self.view)
        
        let homeTitleImage = #imageLiteral(resourceName: "instagram-logo")
        navigationItem.titleView = UIImageView(image: homeTitleImage)
        navigationItem.titleView?.contentMode = .scaleAspectFit
        self.tableView.register(UINib(nibName: "feedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}

// 테이블 생성
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableViewCell") as! feedTableViewCell
        cell.setImagesCell(imageUrls: imageUrls)
        cell.delegate = self
        return cell
    }
}

// tap
extension HomeViewController: feedTableViewCellDelegate {
    
    func tapImage(imageView: UIImageView, index: Int) {
        imageDetailViewer.setImage(imagePaths: imageUrls)
        imageDetailViewer.show(originImageView: imageView, index: index)
    }
}

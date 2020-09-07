//
//  feedModel.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/29.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import Foundation
struct FeedModel: Codable {
    let body, createdAt: String
    let id: Int
    let imageURL: String
    let like: Int
    let updatedAt: String
    let user: UserInfoModel

    enum CodingKeys: String, CodingKey {
        case body, createdAt, id
        case imageURL = "imageUrl"
        case like, updatedAt, user
    }
}

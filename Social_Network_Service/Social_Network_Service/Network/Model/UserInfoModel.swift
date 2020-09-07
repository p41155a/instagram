//
//  UserInfoModel.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/29.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import Foundation

struct UserInfoModel: Codable {
    let address: String
    let bio: String
    let cellPhone: String
    let email: String
    let id: Int
    let image: String
    let username: String
}

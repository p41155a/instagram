//
//  errorModel.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/28.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import Foundation

struct ErrorModel: Codable {
    let code: Int?
    let message: String?
    let log: String?
}

//
//  UserAPIService.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/12.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import Alamofire

let path = "서버 주소 넣는 곳"

enum UserAPIService {
    case login(email: String, password: String)
    case join(email: String, password: String, username: String)
    case userInfo(id: String)
}

extension UserAPIService {
    var url: URL {
        switch self {
        case .login:
            return URL(string: "\(path)/users/login")!
        case .join:
            return URL(string: "\(path)/users/join")!
        case let .userInfo(id):
            return URL(string: "\(path)/users/\(id)")!
        }
    }
    
    var param: Parameters {
        switch self {
        case let .login(email, password):
            return ["email": email, "password": password]
        case let .join(email, password, username):
            return ["email": email, "password": password, "username": username]
        case .userInfo:
            return [:]
        }
    }
    
    var encoding: JSONEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
}

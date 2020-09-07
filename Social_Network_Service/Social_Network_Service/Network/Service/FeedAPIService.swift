//
//  FeedAPIService.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/12.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import Alamofire

enum FeedAPIService {
    case feed
}

extension FeedAPIService {
    var url: URL {
        switch self {
        case .feed:
            return URL(string: "\(path)/posts/feeds/")!
        }
    }
    
    var param: Parameters {
        switch self {
        case .feed:
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

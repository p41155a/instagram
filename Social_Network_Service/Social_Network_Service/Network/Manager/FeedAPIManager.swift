//
//  FeedAPIManager.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/12.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

import UIKit
import Alamofire

struct FeedAPIManager {
    func feed(completion: @escaping () -> (), failure: @escaping (String) -> ()) {
        
        let header: HTTPHeaders = [.accept("application/json")]
        let userAPIService: FeedAPIService = .feed
        AF.request(userAPIService.url, method: .get, parameters: userAPIService.param, encoding: userAPIService.encoding, headers: header)
        .validate()
        .response { response in
            guard let data = response.data else {
                failure("데이터를 받는데 실패하였습니다.")
                return
            }
            do {
                switch response.result {
                case .success:
                    let jsonData = try JSONDecoder().decode(FeedModel.self, from: data)
                    print(jsonData)
                    completion()
                case .failure:
                    let jsonData = try JSONDecoder().decode(ErrorModel.self, from: data)
                    print(jsonData)
                    failure("[\(jsonData.code!)] \(jsonData.message!)")
                }
            } catch let errMessage {
                failure("\(errMessage)")
            }
        }
    }
}


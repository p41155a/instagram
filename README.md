학창시절 재미로 시작하여 완성하지 못한 프로젝트 이지만

alamofire를 사용하여 조금 더 구조를 공통화 할 수 없을 까 살짝이나마 고민했던 프로젝트였습니다.

```swift
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

```



하지만 비슷한 구조인 Moya를 알게 된 후 제 프로젝트에 부족한 점이 많은것 같아

Moya를 정리를 조금 해보려 합니다.



## Moya

Moya 라이브러리는 urlSession, Alamofire를 한 번 더 감싼 통신 API 입니다.

Moya는 열거형을 이용하여 타입이 안전한 방싱으로 네트워크 요청을 캡슐화하여 사용하는 것에 초점이 맞추어져 있습니다.

- Provider: 모든 네트워크 서비스와 상호작용시 사용할 주요 객체입니다. 이를 초기화 할 때 Moya Target을 가지는 일반적인 객체입니다.
- Target: 일반적으로 전체 api를 의미하며 targetType 프로토콜을 채택하는 것으로 target을 정의합니다.



- `baseURL` : 모든 target(서비스)의 baseURL을 명시합니다. Moya는 이를 통하여 endpoint 객체를 생성합니다.
- `path` : Moya는 path를 통하여 라우팅을 합니다. endpoint의 subPath를 정의하며 case에 따른 endpoint를 생성합니다.
- `method` : Target(서비스)의 모든 case를 위하여 정확한 HTTP 메소드를 제공해야합니다.
- `task` : 제일 중요한 프로퍼티입니디. 사용할 모든 endpoint마다 Task 열거형 케이스를 작성해야 하며 기본 요청(plain request), 데이터 요청(data request), 파라미터 요청(parameter request), 업로드 요청(upload request) 등 사용할 수 있는 다양한 task를 제공합니다.
- `sampleData` : 테스트를 위한 목업 데이터를 제공할 떄 사용합니다. 이번 예제에서는 UnitTest를 진행하지 않으므로 빈 Data 객체를 반환합니다.
- `headers` : 모든 target(서비스)의 endpoint 를 위한 HTTP header를 반환합니다. 이번 예제에서 사용하는 모든 endpoint는 JSON 데이터를 반환하기 때문에 `Content-Type: application/JSON` header를 반환하였습니다.



```swift
import Moya

enum GithubAPI {
    case searchUser(query: String)
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .searchUser:
            return "search/users"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .searchUser(let query):
            return .requestParameters(parameters: ["q" : query], encoding: URLEncoding.default)
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        return nil
    }
}
```



```swift
// request 호출
let provider = MoyaProvider<GithubAPI>()
provider.rx.request(.searchUser(query: query))
    .subscribe { [weak self] (event) in
        switch event {
        case .success(let response):
            self?.handleSuccessResponse(response)
        case .error(let error):
            print(error.localizedDescription)
        }
    }
    .disposed(by: disposeBag)
```


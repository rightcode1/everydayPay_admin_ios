//
//  DefaultAPI.swift
//  academyNow
//
//  Created by haon on 2022/05/15.
//

import Foundation
import Moya

enum DefaultAPI {
  case registNotificationToken(param: RegistNotificationTokenRequest)
  case visit
  case version
}

extension DefaultAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .registNotificationToken:
      return "/v1/notification/register"
    case .visit:
      return "/v1/visitors"
    case .version:
      return "/v1/version"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .registNotificationToken:
      return .post
    case .visit,
         .version:
      return .get
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .registNotificationToken(let param):
      return .requestJSONEncodable(param)
    case .visit:
      return .requestPlain
    case .version:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    default:
      if let token = DataHelperTool.token {
        return ["Content-type": "application/json", "Authorization": token]
      } else {
        return ["Content-type": "application/json"]
      }
    }
  }
}

// notification
struct RegistNotificationTokenRequest: Codable {
 let notificationToken: String
}

// version
struct VersionResponse: Codable {
  let statusCode: Int
  let message: String
  let data: Version
}

struct Version: Codable {
  let ios: Int
  let android: Int
}


struct DefaultResponse: Codable {
  let statusCode: Int
  let message: String
}

struct DefaultCodeResponse: Codable {
  let statusCode: Int
  let message: String
}

struct DefaultIDResponse: Codable {
  let statusCode: Int
  let message: String
  let data: DefaultID?
}

struct DefaultID: Codable {
  let id: Int
}

struct Image: Codable {
  let id: Int
  let name: String
}

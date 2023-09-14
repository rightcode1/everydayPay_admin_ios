//
//  NoticeAPI.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/25.
//

import Foundation
import Moya

enum NoticeAPI {
  case list
  case detail(id:Int)
}

extension NoticeAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .list:
      return "/v1/notice/list"
    case .detail:
      return "/v1/notice/detail"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .list,
        .detail:
      return .get
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .list:
      return .requestPlain
    case .detail(let id):
      return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
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

struct BoardListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [BoardData]?
}

struct BoardDetailResponse: Codable {
  let statusCode: Int
  let message: String
  let data: BoardData?
}

struct BoardData: Codable {
  let id: Int
  let title: String
  let content: String?
  let createdAt: String
    
}

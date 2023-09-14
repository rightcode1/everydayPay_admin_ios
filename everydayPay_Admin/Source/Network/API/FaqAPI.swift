//
//  FaqAPI.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/24.
//

import Foundation
import Moya

enum FaqAPI {
  case list
}

extension FaqAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .list:
      return "/v1/faq/list"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .list:
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

// MARK: - FAQListResponse
struct FAQListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [FAQListData]
}

// MARK: - FAQListData
struct FAQListData: Codable {
  let id: Int
  let diff, title, content, createdAt: String
  var isOpened: Bool?
}




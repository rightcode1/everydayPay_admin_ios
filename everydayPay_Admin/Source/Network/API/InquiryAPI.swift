//
//  InquiryAPI.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/24.
//

import Foundation
import Moya

enum InquiryAPI {
  case list
  case InqueryRegister(param: InqueryRegisterRequest)
}

extension InquiryAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .list:
      return "/v1/inquiry/list"
    case .InqueryRegister :
      return "/v1/inquiry/register"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .list:
      return .get
    case .InqueryRegister:
      return .post    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .list:
      return .requestPlain
    case .InqueryRegister(let param):
      return .requestJSONEncodable(param)
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

// MARK: - InquiryListResponse
struct InquiryListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [InquiryData]
}

// MARK: - InquiryData
struct InquiryData: Codable {
  let id: Int
  let name, title, content, createdAt: String
  let comment,commentTitle,memo: String?
  var isOpened: Bool?
}

struct InqueryRegisterRequest: Codable{
  let title, content: String?
}

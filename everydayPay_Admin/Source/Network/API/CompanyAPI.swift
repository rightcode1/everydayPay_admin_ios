//
//  CompanyAPI.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import Moya

enum CompanyAPI {
    case companyList(param: CompnayListRequest)
}

extension CompanyAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .companyList:
      return "/v1/company/list"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .companyList:
      return .get
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .companyList(let param):
      return .requestParameters(parameters: param.dictionary ?? [:], encoding: URLEncoding.queryString)
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
struct CompanyListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [CompanyData]
}

// MARK: - UserInfoData
struct CompanyData: Codable {
  var id: Int
//    var companyTel,thumbnail: String?
    var name,owner,businessNumber,tel,address,addressDetail: String
//    var latitude,longitude,createdAt: String
//    var idactive : Bool
}

struct CompnayListRequest: Codable {
  let search: String?
  
  init(
    search: String? = nil
  ) {
    self.search = search
  }
}


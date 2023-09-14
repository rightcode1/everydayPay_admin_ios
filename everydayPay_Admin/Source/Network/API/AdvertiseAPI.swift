//
//  AdvertisementAPI.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/18.
//

import Foundation
import Moya

enum AdvertiseAPI {
  case advertisementList(param: AdvertisementListRequest)
}

extension AdvertiseAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .advertisementList : return "/v1/advertisement/list"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case.advertisementList:
      return .get
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .advertisementList(let param) :
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


struct AdvertisementListRequest: Codable {
  let userDiff: AdUserDiff
  let location: AdLocation
}

enum AdLocation: String, Codable {
  case 메인배너 = "메인배너"
  case 팝업 = "팝업"
}
enum AdUserDiff: String, Codable {
  case 유저 = "유저"
  case 업체 = "업체"
}
struct AdListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [AdvertisementData]
}

// MARK: - UserInfoData
struct AdvertisementData: Codable {
  var id: Int
  var thumbnail: String
}


//
//  AuthAPI.swift
//  academyNow
//
//  Created by haon on 2022/05/15.
//

import Foundation
import Moya

enum AuthAPI {
  case versionCheck
  case existLoginId(loginId: String)
  case certificationNumberSMS(tel: String, diff: CertificationNumberSMSDiff)
  case confirm(tel: String, confirm: String)
  case join(param: JoinRequest)
  case login(param: LoginRequest)
  case findLoginId(tel: String)
  case passwordChange(param: PasswordChangeRequest)
  
  case existNickname(name: String)
}

extension AuthAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .versionCheck : return "/v1/version"
    case .existLoginId:
      return "/v1/auth/existLoginId"
    case .certificationNumberSMS:
      return "/v1/auth/certificationNumberSMS"
    case .confirm:
      return "/v1/auth/confirm"
    case .join:
      return "/v1/auth/join"
    case .login:
      return "/v1/auth/login"
    case .findLoginId:
      return "/v1/auth/findLoginId"
    case .passwordChange:
      return "/v1/auth/passwordChange"
    case .existNickname:
      return "/v1/auth/existName"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case
        .join,
        .login,
        .passwordChange:
      return .post
    case
        .versionCheck,
        .existLoginId,
        .confirm,
        .certificationNumberSMS,
        .findLoginId,
        .existNickname:
      return .get
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .versionCheck :
      return .requestPlain
    case .existLoginId(let loginId):
      return .requestParameters(parameters: ["loginId": loginId], encoding: URLEncoding.queryString)
    case .certificationNumberSMS(let tel, let diff):
      return .requestParameters(parameters: ["tel": tel, "diff": diff], encoding: URLEncoding.queryString)
    case .confirm(let tel, let confirm):
      return .requestParameters(parameters: ["tel": tel, "confirm": confirm], encoding: URLEncoding.queryString)
    case .join(let param):
      return .requestJSONEncodable(param)
    case .login(let param):
      return .requestJSONEncodable(param)
    case .findLoginId(let tel):
      return .requestParameters(parameters: ["tel": tel], encoding: URLEncoding.queryString)
    case .passwordChange(let param):
      return .requestJSONEncodable(param)
    case .existNickname(let name):
      return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
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

enum CertificationNumberSMSDiff: String, Codable {
  case join = "join"
  case find = "find"
  case update = "update"
  case login = "login"
}

struct JoinRequest: Codable {
  let loginId: String
  let password: String
  let tel: String
  let name: String
  let nickname: String
  let gender: Gender
  let age: String
  let inflow: [String]
  let skin: [String]
  let face: [String]
  let body: [String]
}

enum Age: String, Codable {
  case ten = "10대"
  case twenty = "20대"
  case thirty = "30대"
  case forty = "40대"
  case fifty = "50대"
  case sixty = "60대"
}

enum Gender: String, Codable {
  case 남성 = "남성"
  case 여성 = "여성"
}

enum JoinSkin: String, Codable {
  case 수분 = "수분"
  case 모공 = "모공"
  case 피지 = "피지"
  case 예민 = "예민"
  case 트러블 = "트러블"
}

enum JoinFace: String, Codable {
  case 얼굴축소 = "얼굴축소"
  case 이목구비관리 = "이목구비관리"
  case 광대축소 = "광대축소"
  case 웨딩관리 = "웨딩관리"
}

enum JoinBody: String, Codable {
  case 복부 = "복부"
  case 등 = "등"
  case 가슴 = "가슴"
  case 하체 = "하체"
  case 힙 = "힙"
}

struct LoginRequest: Codable {
  let loginId: String
  let password: String
}

struct LoginResponse: Codable {
  let statusCode: Int
  let message: String
  let token: String?
  let userId: Int?
}

struct FindIDResponse: Codable {
  let statusCode: Int
  let message: String
  let data: FindIDData?
  
  struct FindIDData: Codable {
    let loginId: String
  }
}

struct PasswordChangeRequest: Codable {
  let tel: String
  let loginId: String
  let password: String
}

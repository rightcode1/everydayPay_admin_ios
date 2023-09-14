//
//  UserAPI.swift
//  academyNow
//
//  Created by haon on 2022/05/18.
//

import Foundation
import Moya

enum UserAPI {
  case userLogout
  case userInfo
  case userList(tel:String)
  case userRegister(param: UserRegisterRequest)
  case userUpdate(param: UpdateUserRequest)
  case userFileRegister(image: UIImage)
  
  case withdrawal
}

extension UserAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .userLogout:
      return "/v1/user/logout"
    case .userInfo:
      return "/v1/user/info"
    case .userList:
      return "/v1/user/list"
    case .userUpdate:
      return "/v1/user/update"
    case .userFileRegister:
      return "/v1/user/file/register"
    case .userRegister:
      return "/v1/auth/admin/join"
    case .withdrawal:
      return "/v1/user/withdrawal"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userLogout,
        .userList,
            .userInfo:
      return .get
    case .userUpdate:
      return .put
    case .userFileRegister,
          .userRegister:
      return .post
    case .withdrawal:
      return .delete
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .userLogout:
      return .requestPlain
    case .userInfo:
      return .requestPlain
    case .userUpdate(let param):
      return .requestJSONEncodable(param)
    case .userList(let tel):
      return .requestParameters(parameters: ["tel": tel], encoding: URLEncoding.queryString)
    case .userRegister(let param):
      return .requestJSONEncodable(param)
    case .userFileRegister(let image):
      let multipart = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0.1)!), name: "image", fileName: "image.jpg", mimeType: "image/jpeg")
      return .uploadCompositeMultipart(
        [multipart], urlParameters: [:]
      )
    case .withdrawal:
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

// MARK: - UserInfoResponse
struct UserInfoResponse: Codable {
  let statusCode: Int
  let message: String
  let data: UserInfoData
}
struct UserListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [OtherUser]
}

// MARK: - UserInfoData
struct UserInfoData: Codable {
  var id: Int
  var companyId: Int?
  var thumbnail: String?
  var loginId: String?
  var name: String
  var tel: String?
  var companyName: String?
  var newsAgency: String?
}



struct UpdateUserRequest: Codable {
  var name: String
  var nickname: String?
  var tel: String?
  var age: String?
  var inflow: [String]
  var skin: [String]
  var face: [String]
  var body: [String]
  var etc: String?
  
  func isEqualValue(with other: UpdateUserRequest) -> Bool {
    if name == other.name && tel == other.tel && nickname == other.nickname && age == other.age && inflow == other.inflow && skin == other.skin && face == other.face && body == other.body && etc == other.etc {
      return true
    } else {
      return false
    }
  }
}

struct UserRegisterRequest: Codable {
  var loginId: String
  var password: String
  var newsAgency: String
  var tel: String
  var name: String
  var companyId: Int
}

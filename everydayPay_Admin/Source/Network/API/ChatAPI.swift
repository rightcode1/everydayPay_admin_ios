//
//  ChatAPI.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/12.
//

import Foundation
import Moya

enum ChatAPI {
  case list(diff: String)
  case regist(param:ChatRegisterRequest)
  case userList(chatRoomId: Int)
  case userOut(chatRoomId: Int,userId: Int,diff:String)
  case joinUser(param:ChatJoinRequest)
  case joinUserList(search: String,diff: String)
}

extension ChatAPI: TargetType {
  public var baseURL: URL {
    switch self {
    default:
      return URL(string: ApiEnvironment.baseUrl)!
    }
  }
  
  var path: String {
    switch self {
    case .list:
      return "/v1/chatRoom/list"
    case .regist:
      return "/v1/chatRoom/register"
    case .userList:
      return "/v1/chatRoomJoin/list"
    case .userOut:
      return "/v1/chatRoomJoin/remove"
    case .joinUser:
      return "/v1/chatRoomJoin/register"
    case .joinUserList:
      return "/v1/chatRoomList/list"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userList,
          .joinUserList,
          .list:
      return .get
    case .joinUser,
        .regist:
      return .post
    case .userOut:
      return .delete
    }
  }
  
  var sampleData: Data {
    return "!!".data(using: .utf8)!
  }
  
  var task: Task {
    switch self {
    case .list(let diff):
      return .requestParameters(parameters: ["diff": diff], encoding: URLEncoding.queryString)
    case .userList(let chatRoomId):
      return .requestParameters(parameters: ["chatRoomId": chatRoomId], encoding: URLEncoding.queryString)
    case .userOut(let chatRoomId, let userId,let diff):
      return .requestParameters(parameters: ["chatRoomId": chatRoomId ,"userId":userId,"diff":diff], encoding: URLEncoding.queryString)
    case .joinUserList(let search ,let diff):
      return .requestParameters(parameters: ["search": search ,"diff":diff], encoding: URLEncoding.queryString)
    case .joinUser(let param):
      return .requestJSONEncodable(param)
    case .regist(let param):
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

struct ChatListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [ChatData]
}

struct ChatData: Codable {
  var id: Int?
  var title: String?
  var message: String?
  var updatedAt: String?
  var diff: String?
  
  init(dict: [String:Any]) {
    if let obj = dict["id"] {
      self.id = obj as? Int
    }
    if let obj = dict["title"] {
      self.title = (obj as! String)
    }
    if let obj = dict["message"] {
      self.message = (obj as! String)
    }
    if let obj = dict["updatedAt"] {
      self.updatedAt = obj as? String
    }
    
    if let obj = dict["diff"] {
      self.diff = obj as? String
    }
  }
}
struct ChatRegisterRequest: Codable{
  let title, diff: String?
  let userId: Int?
}
struct ChatUserListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [ChatUser]
}
struct ChatUser: Codable {
  var id: Int?
  var userId: Int?
  var chatRoomId: Int?
  var userName: String?
  var isHost: Bool?
  var isSelect: Bool? = false
}

struct ChatJoinRequest: Codable{
  let userId: [Int]
  let chatRoomId: Int
}

struct ChatJoinUserListResponse: Codable {
  let statusCode: Int
  let message: String
  let list: [ChatJoinUser]
}
struct ChatJoinUser: Codable {
  var userId: Int?
  var userRole: String?
  var teamLeaderName: String?
  var userName: String?
  var isSelect: Bool? = false
}

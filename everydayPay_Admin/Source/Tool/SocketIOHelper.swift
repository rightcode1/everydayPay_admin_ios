//
//  SocketIOHelper.swift
//  locallage
//
//  Created by hoonKim on 2020/08/20.
//  Copyright © 2020 DongSeok. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
  static let sharedInstance = SocketIOManager()
  
  let manager = SocketManager(socketURL: URL(string: "http://3.34.221.235:6670")!, config: [.log(true), .path("/socket.io"), .compress, .reconnects(true), .forceWebsockets(true)])
  
  var isConnected: Bool = false
  
  override init() {
    super.init()
    manager.defaultSocket.on(clientEvent: .connect) { data, ack in
      print("socket data : \(data)")
      print("socket ack : \(ack)")
      print("----socket connected----")
      print("token: \(DataHelperTool.chatToken ?? "")")
      self.manager.defaultSocket.emit("login", ["token": DataHelperTool.chatToken ?? ""])
    }
  }
  
  func connection() {
    manager.defaultSocket.connect()
    isConnected = true
  }
  
  func disConnection() {
    manager.defaultSocket.disconnect()
    isConnected = false
  }
  
  func getRoomList(diff: String, result: @escaping ([[String: Any]]) -> Void) {
    manager.defaultSocket.emitWithAck("getList", ["diff":"\(diff)"]).timingOut(after: 0) { data in
      guard let listData = data[0] as? [String: Any] else { return }
      let list = listData["list"] as? [[String: Any]]
      print(listData)
      result(list ?? [])
    }
  }
  
  func roomListUpdate(result: @escaping ([[String: Any]]) -> Void) {
    manager.defaultSocket.on("listUpdate") { data, ack  in
      guard let listData = data[0] as? [String: Any] else { return }
      let list = listData["data"] as? [[String: Any]]
      
      result(list ?? [])
    }
  }
  
  func enterRoom(chatRoomId: Int,diff:String, result: @escaping (([ChatMessage])) -> Void) {
    manager.defaultSocket.emitWithAck("enterRoom", ["chatRoomId": "\(chatRoomId)","diff":"\(diff)"]).timingOut(after: 0) { data in
      guard let responseData = data[0] as? [String: Any] else { return }
      let list = responseData["data"] as? [[String: Any]]
      
      var messageList: [ChatMessage] = []
      
      if (list ?? []).count > 0 {
        for data in list! {
          messageList.append(ChatMessage(dict: data))
        }
      }
      
      result(messageList)
    }
  }
  
  func outRoom(chatRoomId: Int, result: @escaping (Bool) -> Void) {
    manager.defaultSocket.emitWithAck("outRoom", ["chatRoomId": "\(chatRoomId)"]).timingOut(after: 0) { data in
      guard let responseData = data[0] as? [String: Any] else { return }
      let success = responseData["result"] as? Bool
      
      result(success ?? false)
    }
  }
  
  func messageRefresh(result: @escaping (ChatMessage) -> Void) {
    manager.defaultSocket.on("messageRefresh") { data, ack  in
      guard let messageData = data[0] as? [String: Any] else { return }
      print("messageData: \(messageData)")
      result(ChatMessage(dict: messageData))
    }
  }
  
  func sendMessage( message: String) {
    manager.defaultSocket.emit("sendMessage", ["message": message])
  }
  
  func sendImage(chatRoomId: Int, messageId: Int) {
    manager.defaultSocket.emit("sendMessage", ["chatRoomId": "\(chatRoomId)", "messageId": "\(messageId)"])
  }
  
  func checkOutRoom() {
    manager.defaultSocket.emit("checkout")
  }
  
}

struct ChatMessage: Codable {
  var id: Int?
  var type: String?
  var content: String?
  var userName: String?
  var thumbnail: String?
  var userId: Int?
  var readAt: String?
  var createdAt: String?
  
  init(dict: [String:Any]) {
    if let obj = dict["id"] {
      self.id = obj as? Int
    }
    
    
    if let obj = dict["type"] {
      self.type = obj as? String
    }
    
    if let obj = dict["content"] {
      self.content = (obj as! String)
    }
    
    if let obj = dict["userName"] {
      self.userName = obj as? String
    }
    
    if let obj = dict["thumbnail"] {
      self.thumbnail = obj as? String
    }
    
    if let obj = dict["userId"] {
      self.userId = obj as? Int
    }
    
    if let obj = dict["readAt"] {
      self.readAt = obj as? String
    }
    
    if let obj = dict["createdAt"] {
      self.createdAt = obj as? String
    }
  }
}

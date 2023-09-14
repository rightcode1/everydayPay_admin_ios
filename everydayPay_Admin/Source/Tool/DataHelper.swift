//
//  DataHelper.swift
//  OPenPal
//
//  Created by jason on 11/10/2018.
//  Copyright © 2018 WePlanet. All rights reserved.
//

import Foundation
//import FirebaseMessaging

class DataHelper<T> {
  
  enum DataKeys: String {
      case userLoginId = "userLoginId"
      case userPw = "userPw"
      case userId = "userId"
    case token = "token"
    case chatToken = "chatToken"
    case userAppId = "userAppId"
    case childrenAppId = "childrenAppId"
    case userStoreId = "userStoreId"
    case popupDate = "popupDate"
    case isSawGuide = "isSawGuide"
    case newOrderCount = "totalOrderCount"
  }
  
  class func value(forKey key: DataKeys) -> T? {
    if let data = UserDefaults.standard.value(forKey: key.rawValue) as? T {
      return data
    } else {
      return nil
    }
  }
  
  class func set(_ value:T, forKey key: DataKeys) {
    UserDefaults.standard.set(value, forKey : key.rawValue)
  }
  
  class func remove(forKey key: DataKeys) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
  
  class func clearAll() {
    UserDefaults.standard.dictionaryRepresentation().keys.forEach{ key in
      UserDefaults.standard.removeObject(forKey: key.description)
    }
  }
}

class DataHelperTool {
  
  static var userLoginId: String? {
    guard let userLoginId = DataHelper<String>.value(forKey: .userLoginId) else { return nil }
    return userLoginId
  }
  
  static var userPw: String? {
    guard let userPasswword = DataHelper<String>.value(forKey: .userPw) else { return nil }
    return userPasswword
  }
  
  static var token: String? {
    guard let token = DataHelper<String>.value(forKey: .token) else { return nil }
    return token
  }
  
  static var chatToken: String? {
    guard let chatToken = DataHelper<String>.value(forKey: .chatToken) else { return nil }
    return chatToken
  }
    static var userId: Int? {
      guard let userId = DataHelper<Int>.value(forKey: .userId) else { return nil }
      return userId
    }
  
  static var userAppId: Int? {
    guard let userAppId = DataHelper<Int>.value(forKey: .userAppId) else { return nil }
    return userAppId
  }
  
  static var childrenAppId: Int? {
    guard let childrenId = DataHelper<Int>.value(forKey: .childrenAppId) else { return nil }
    return childrenId
  }
  
  static var userStoreId: Int? {
    guard let userStoreId = DataHelper<Int>.value(forKey: .userStoreId) else { return nil }
    return userStoreId
  }
  
  static var popupDate: String? {
    guard let popupDate = DataHelper<String>.value(forKey: .popupDate) else { return nil }
    return popupDate
  }
  
  static var isSawGuide: Bool? {
    guard let isSawGuide = DataHelper<Bool>.value(forKey: .isSawGuide) else { return nil }
    return isSawGuide
  }
  
  static var newOrderCount: Int? {
    guard let newOrderCount = DataHelper<Int>.value(forKey: .newOrderCount) else { return nil }
    return newOrderCount
  }
}
  

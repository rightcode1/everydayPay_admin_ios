//
//  APIProvider.swift
//  coffitForManager
//
//  Created by 이동석 on 2022/03/10.
//

import Foundation
import Moya

final class APIProvider {
  
  static let shared = APIProvider()
  
  var defaultAPI = MoyaProvider<DefaultAPI>()
  var authAPI = MoyaProvider<AuthAPI>()
  var userAPI = MoyaProvider<UserAPI>()
  var companyAPI = MoyaProvider<CompanyAPI>()
  var advertiseAPI = MoyaProvider<AdvertiseAPI>()
  var manageAPI = MoyaProvider<ManageAPI>()
  var faqAPI = MoyaProvider<FaqAPI>()
  var inquiryAPI = MoyaProvider<InquiryAPI>()
  var noticeAPI = MoyaProvider<NoticeAPI>()
  var chatAPI = MoyaProvider<ChatAPI>()
 
  
  private init() {
    defaultAPI = MoyaProvider<DefaultAPI>(plugins: [MoyaLoggingPlugin()])
    authAPI = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
    userAPI = MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])
    companyAPI = MoyaProvider<CompanyAPI>(plugins: [MoyaLoggingPlugin()])
    advertiseAPI = MoyaProvider<AdvertiseAPI>(plugins: [MoyaLoggingPlugin()])
    manageAPI = MoyaProvider<ManageAPI>(plugins: [MoyaLoggingPlugin()])
    faqAPI = MoyaProvider<FaqAPI>(plugins: [MoyaLoggingPlugin()])
    inquiryAPI = MoyaProvider<InquiryAPI>(plugins: [MoyaLoggingPlugin()])
    noticeAPI = MoyaProvider<NoticeAPI>(plugins: [MoyaLoggingPlugin()])
    chatAPI = MoyaProvider<ChatAPI>(plugins: [MoyaLoggingPlugin()])
  
  }
  
  func getErrorStatusResponse(_ error: Error) -> DefaultResponse {
    let moayError: MoyaError? = error as? MoyaError
    let response: DefaultResponse? = moayError?.backendError
    return response ?? DefaultResponse(statusCode: 0, message: "error")
  }
}

extension MoyaError {
  var backendError: DefaultResponse? {
    return response.flatMap {
      try? $0.map(DefaultResponse.self)
    }
  }
}


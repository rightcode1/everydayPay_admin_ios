//
//  Environment.swift
//  InsideROO
//
//  Created by jason on 02/02/2019.
//  Copyright © 2019 Dong Seok Lee. All rights reserved.
//

import Foundation
import UIKit

var FcmToken: String = ""

var currentLocation: (Double, Double)?

struct ApiEnvironment {
    static let baseUrl = "http://3.34.221.235:6670"
    static let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as! String
    static let kakaoRESTKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_KEY") as! String
    //  static let serverGatewayStage = Bundle.main.object(forInfoDictionaryKey: "SERVER_GATEWAY_STAGE") as! String
}

extension Encodable {
  var dictionary: [String: Any]? {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = [.prettyPrinted]
    guard let data = try? jsonEncoder.encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}

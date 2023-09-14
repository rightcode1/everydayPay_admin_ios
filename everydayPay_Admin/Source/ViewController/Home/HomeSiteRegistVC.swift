//
//  HomeSiteRegistVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/08.
//

import Foundation

class HomeSiteRegistVC:BaseViewController,ViewControllerFromStoryboard{
  static func viewController() -> HomeSiteRegistVC {
    let viewController = HomeSiteRegistVC.viewController(storyBoardName: "Home")
    return viewController
  }
  
  var id : Int = -1
  var isRegist: Bool = false
  var siteList: [SiteList] = []
  var scehdule: [CalendarData] = []
  private var selectDate: Date = Date(timeIntervalSinceNow: 86400)
  
  override func viewWillAppear(_ animated: Bool) {
  }
}

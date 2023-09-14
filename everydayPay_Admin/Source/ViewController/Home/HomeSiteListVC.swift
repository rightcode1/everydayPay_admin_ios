//
//  HomeSiteListVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/08.
//

import Foundation
import UIKit
import SwiftUI

protocol siteRegistProtocol{
  func getSiteUpdate()
}
class HomeSiteListVC:BaseViewController,ViewControllerFromStoryboard{
  static func viewController() -> HomeSiteListVC {
    let viewController = HomeSiteListVC.viewController(storyBoardName: "Home")
    return viewController
  }
  
  @IBOutlet weak var mainTableView: UITableView!
  
  var delegate: siteRegistProtocol?
  
  var homeCategory: HomeCategory?
  var homeSecondCategory: String?
  var siteList: [SiteData] = []
  
  override func viewWillAppear(_ animated: Bool) {
    mainTableView.delegate = self
    mainTableView.dataSource = self
    mainTableView.layoutTableHeaderView()
    userInfo(result: { result in
      self.initSiteList(result.data.companyId ?? 0)
    })
  }
  func initSiteList(_ id: Int) {
    APIProvider.shared.manageAPI.rx.request(.siteList(id: id))
      .filterSuccessfulStatusCodes()
      .map(SiteListResponse.self)
      .subscribe(onSuccess: { value in
        self.siteList = value.list
        self.mainTableView.reloadData()
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  
  
}
extension HomeSiteListVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return siteList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    guard let activeLabel = cell.viewWithTag(1) as? UILabel,
          let addressLabel = cell.viewWithTag(2) as? UILabel,
          let titleLabel = cell.viewWithTag(3) as? UILabel,
          let companyLabel = cell.viewWithTag(4) as? UILabel,
          let createLabel = cell.viewWithTag(5) as? UILabel else {
      return cell
    }
    let dict = siteList[indexPath.row]
    activeLabel.text = dict.active ? "승인완료" : "승인대기"
    activeLabel.textColor = dict.active ? .green : .red
    addressLabel.text = dict.address
    titleLabel.text = dict.name
    companyLabel.text = dict.companyName
    createLabel.text = dict.createdAt
      return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.getSiteUpdate()
    backPress()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
    
  }
  
}

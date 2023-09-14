//
//  HomeCategoryList.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/06.
//

import Foundation
import UIKit

class HomeCategoryListVC:BaseViewController,ViewControllerFromStoryboard{
  static func viewController() -> HomeCategoryListVC {
    let viewController = HomeCategoryListVC.viewController(storyBoardName: "Home")
    return viewController
  }
  
  @IBOutlet weak var mainTableView: UITableView!
  @IBOutlet weak var registButton: UIButton!
  
  var homeCategory: HomeCategory?
  var homeSecondCategory: String?
  var scheduleList: [ManageData] = []
  
  override func viewWillAppear(_ animated: Bool) {
    mainTableView.delegate = self
    mainTableView.dataSource = self
    mainTableView.layoutTableHeaderView()
    initSchedule()
  }
  override func viewDidLoad() {
    initrx()
  }
  func initSchedule() {
    let param = JobListRequest(category: homeCategory?.rawValue, subCategory: homeSecondCategory)
    APIProvider.shared.manageAPI.rx.request(.jobList(param: param))
      .filterSuccessfulStatusCodes()
      .map(ManageListResponse.self)
      .subscribe(onSuccess: { value in
        self.scheduleList = value.list
        self.mainTableView.reloadData()
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  func initrx(){
    registButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = HomeCategoryDetailVC.viewController()
        vc.homeCategory = self.homeCategory
        vc.isRegist = true
        self.navigationController?.pushViewController(vc, animated: true)
        
      })
      .disposed(by: disposeBag)
  }
  
  
}
extension HomeCategoryListVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return scheduleList.count
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
    let dict = scheduleList[indexPath.row]
    activeLabel.text = dict.active ? "승인완료" : "승인대기"
    activeLabel.textColor = dict.active ? .green : .red 
    addressLabel.text = dict.address
    titleLabel.text = dict.siteName
    companyLabel.text = dict.companyName
    createLabel.text = dict.createdAt
      return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = HomeCategoryDetailVC.viewController()
    vc.id = scheduleList[indexPath.row].id
    vc.homeCategory = homeCategory
    vc.isRegist = false
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
    
  }
  
}

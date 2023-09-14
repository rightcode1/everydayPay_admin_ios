//
//  ManageVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/18.
//

import Foundation
import UIKit

class ManageVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ManageVC {
      let viewController = ManageVC.viewController(storyBoardName: "Manage")
      return viewController
  }
  @IBOutlet weak var mainTableView: UITableView!
  
  var manageList: [ManageData] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initTableView()
    initManageList()
  }
  func initTableView(){
    mainTableView.delegate = self
    mainTableView.dataSource = self
  }
  
  func initManageList() {
    let param = JobListRequest()
      APIProvider.shared.manageAPI.rx.request(.jobList(param: param))
          .filterSuccessfulStatusCodes()
          .map(ManageListResponse.self)
          .subscribe(onSuccess: { value in
            self.manageList = value.list
            self.mainTableView.reloadData()
          }, onError: { error in
          })
          .disposed(by: disposeBag)
  }
  
}
extension ManageVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return manageList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManageListCell
    let dict = manageList[indexPath.row]
    cell.delegate = self
    cell.initupdate(data: dict)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 182
    return UITableView.automaticDimension
  }
  
}
extension ManageVC: tapManageProtocol{
  func tapApplicant(id: Int) {
    let vc = ManageDetailVC.viewController()
    vc.isApplicant = true
    vc.id = id
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func tapAttendance(id: Int) {
    let vc = ManageDetailVC.viewController()
    vc.isAttendance = true
    vc.id = id
    self.navigationController?.pushViewController(vc, animated: true)
  }

  func tapNotice(id: Int) {
    let vc = ManageNoticeVC.viewController()
    vc.jobId = id
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

//
//  LaborVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/08.
//

import Foundation
import UIKit

class LaborVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> LaborVC {
      let viewController = LaborVC.viewController(storyBoardName: "Labor")
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
    mainTableView.layoutTableHeaderView()
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
extension LaborVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return manageList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = LaborDetailVC.viewController()
    vc.isApplicant = true
    vc.id = manageList[indexPath.row].id
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 182
    return UITableView.automaticDimension
  }
  
}


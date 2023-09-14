//
//  ManageNoticeVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/16.
//

import Foundation
import UIKit

class ManageNoticeVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ManageNoticeVC {
    let viewController = ManageNoticeVC.viewController(storyBoardName: "Manage")
    return viewController
  }
  @IBOutlet weak var mainTableView: UITableView!
  
  @IBOutlet weak var registNoticeButton: UIBarButtonItem!
  var noticeList: [BoardList] = []
  var jobId: Int = -1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initTableView()
    initManageList()
    initrx()
  }
  func initTableView(){
    mainTableView.delegate = self
    mainTableView.dataSource = self
  }
  
  func initManageList() {
    APIProvider.shared.manageAPI.rx.request(.noticeList(id: jobId))
      .filterSuccessfulStatusCodes()
      .map(ManageBoardListResponse.self)
      .subscribe(onSuccess: { value in
        self.noticeList = value.list
        self.mainTableView.reloadData()
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  func initrx(){
    registNoticeButton.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        let vc = ManageNoticeRegistVC.viewController()
        vc.id = self.jobId
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
}
extension ManageNoticeVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return noticeList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let dict = noticeList[indexPath.row]
    guard let title = cell.viewWithTag(1) as? UILabel,
          let content = cell.viewWithTag(2) as? UILabel,
          let name = cell.viewWithTag(3) as? UILabel,
          let date = cell.viewWithTag(4) as? UILabel else { return cell }
    title.text = dict.title
    content.text = dict.content
    name.text = dict.userName
    date.text = dict.createdAt
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = ManageNoticeDetailVC.viewController()
    vc.id = noticeList[indexPath.row].id
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 182
    return UITableView.automaticDimension
  }
  
}

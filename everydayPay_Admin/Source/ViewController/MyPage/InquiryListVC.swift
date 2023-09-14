//
//  InquiryListVC.swift
//  camver
//
//  Created by hoon Kim on 2022/03/02.
//

import UIKit
import Alamofire

class InquiryListVC: BaseViewController, ViewControllerFromStoryboard {
  
  static func viewController() -> InquiryListVC {
    let viewController = InquiryListVC.viewController(storyBoardName: "MyPage")
    return viewController
  }
  
  @IBOutlet var tableView: UITableView!
//  @IBOutlet var noInqueryImageView: UIImageView!
  
  var inquiryList: [InquiryData] = []
  private var selectedRow: Int = -1
  private var removeId: Int = -1
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.estimatedRowHeight = 71
  }
  
  override func viewWillAppear(_ animated: Bool) {
    inquiryListApi()
  }
  
  func inquiryListApi() {
    APIProvider.shared.inquiryAPI.rx.request(.list)
      .filterSuccessfulStatusCodes()
      .map(InquiryListResponse.self)
      .subscribe(onSuccess: { value in
        if(value.statusCode <= 202){
          self.dismissHUD()
          self.inquiryList = value.list
          if self.inquiryList.isEmpty{
//            self.noInqueryImageView.isHidden = false
          }else{
//            self.noInqueryImageView.isHidden = true
          }
          self.tableView.reloadData()
        }
        self.dismissHUD()
      }, onError: { error in
        self.dismissHUD()
      })
      .disposed(by: disposeBag)
  }
  
  @IBAction func tapRegistInquiry(_ sender: UIButton) {
    let vc = InquiryRegistController.viewController()
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
extension InquiryListVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return inquiryList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell") as! InquiryListCell
    let data = inquiryList[indexPath.row]

    cell.update(data)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    var updateIndexPath: [IndexPath] = []
    
    if self.selectedRow == indexPath.row {
      let preIndexPath = IndexPath(row: self.selectedRow, section: indexPath.section)
      self.inquiryList[self.selectedRow].isOpened = false
      updateIndexPath.append(preIndexPath)
      self.selectedRow = -1
      
    } else {
      if self.selectedRow != -1 {
        let preIndexPath = IndexPath(row: self.selectedRow, section: indexPath.section)
        self.inquiryList[self.selectedRow].isOpened = false
        updateIndexPath.append(preIndexPath)
      }
      
      self.selectedRow = indexPath.row
      self.inquiryList[indexPath.row].isOpened = true
      updateIndexPath.append(indexPath)
    }
    
    self.tableView.reloadRows(at: updateIndexPath, with: .none)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.layoutMargins = .zero
    cell.separatorInset = .zero
    cell.selectionStyle = .none
    cell.preservesSuperviewLayoutMargins = false
  }
  
}

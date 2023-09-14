//
//  FAQVC.swift
//  PlayAround
//
//  Created by haon on 2022/06/20.
//

import UIKit

class FAQVC: BaseViewController, ViewControllerFromStoryboard {
  
  static func viewController() -> FAQVC {
    let viewController = FAQVC.viewController(storyBoardName: "MyPage")
    return viewController
  }
  
  @IBOutlet weak var mainTableView: UITableView!
  
  
  var faqList: [FAQListData] = []
  private var selectedRow: Int = -1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTableView()
    initFAQList()
  }
  
  func setTableView() {
    mainTableView.delegate = self
    mainTableView.dataSource = self
  }
  
  func initFAQList() {
    APIProvider.shared.faqAPI.rx.request(.list)
      .filterSuccessfulStatusCodes()
      .map(FAQListResponse.self)
      .subscribe(onSuccess: { response in
        self.faqList = response.list
        self.mainTableView.reloadData()
      }, onError: { error in
        self.showToast(message: error.localizedDescription, yPosition: APP_HEIGHT() - 250)
      })
      .disposed(by: disposeBag)
  }
  
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return faqList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FAQListCell
    let data = faqList[indexPath.row]
    
    cell.index = indexPath.row
    cell.update(data)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if faqList.count > 0 {
      var updateIndexPath: [IndexPath] = []
      
      if self.selectedRow == indexPath.row {
        let preIndexPath = IndexPath(row: self.selectedRow, section: indexPath.section)
        self.faqList[self.selectedRow].isOpened = false
        updateIndexPath.append(preIndexPath)
        self.selectedRow = -1
        
      } else {
        if self.selectedRow != -1 {
          let preIndexPath = IndexPath(row: self.selectedRow, section: indexPath.section)
          self.faqList[self.selectedRow].isOpened = false
          updateIndexPath.append(preIndexPath)
        }
        
        self.selectedRow = indexPath.row
        self.faqList[indexPath.row].isOpened = true
        updateIndexPath.append(indexPath)
      }
      
      self.mainTableView.reloadRows(at: updateIndexPath, with: .none)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.layoutMargins = .zero
    cell.separatorInset = .zero
    cell.selectionStyle = .none
    cell.preservesSuperviewLayoutMargins = false
  }
  
}

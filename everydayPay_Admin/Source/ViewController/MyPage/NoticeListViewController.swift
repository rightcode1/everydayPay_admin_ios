//
//  NoticeListViewController.swift
//  ppuryo
//
//  Created by hoonKim on 2021/05/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoticeListViewController: BaseViewController, ViewControllerFromStoryboard {
  
  static func viewController() -> NoticeListViewController {
    let viewController = NoticeListViewController.viewController(storyBoardName: "MyPage")
    return viewController
  }
  
  @IBOutlet weak var mainTableView: UITableView!
  
  var boardList: [BoardData] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainTableView.delegate = self
    mainTableView.dataSource = self
    initNoticeList()
  }
  func initNoticeList() {
    APIProvider.shared.noticeAPI.rx.request(.list)
      .filterSuccessfulStatusCodes()
      .map(BoardListResponse.self)
      .subscribe(onSuccess: { value in
        DispatchQueue.global().sync {
          self.boardList.removeAll()
          self.boardList = value.list ?? []
          
          DispatchQueue.main.async {
            self.mainTableView.reloadData()
            self.dismissHUD()
          }
        }
        self.dismissHUD()
      }, onError: { error in
        self.dismissHUD()
      })
      .disposed(by: disposeBag)
  }
  
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension NoticeListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return boardList.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell")!
    let dict = boardList[indexPath.row]
    
    let titleLabel = (cell.viewWithTag(1) as! UILabel)
    let dateLabel = (cell.viewWithTag(2) as! UILabel)
    
    titleLabel.text = dict.title
    dateLabel.text = dict.createdAt
    
    cell.selectionStyle = .none
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let vc = NoticeDetailViewController.viewController()
    vc.id = boardList[indexPath.row].id
    self.navigationController?.pushViewController(vc, animated: true)
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 75
    
    
  }
  
}

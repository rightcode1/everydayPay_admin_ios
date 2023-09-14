//
//  NoticeDetailViewController.swift
//  ppuryo
//
//  Created by hoonKim on 2021/05/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoticeDetailViewController: BaseViewController, ViewControllerFromStoryboard {
  
  static func viewController() -> NoticeDetailViewController {
    let viewController = NoticeDetailViewController.viewController(storyBoardName: "MyPage")
    return viewController
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  var id: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    boardDetailData()
  }
  
  func boardDetailData() {
    APIProvider.shared.noticeAPI.rx.request(.detail(id: id))
      .filterSuccessfulStatusCodes()
      .map(BoardDetailResponse.self)
      .subscribe(onSuccess: { value in
        self.titleLabel.text = value.data?.title
        self.contentLabel.text = value.data?.content
        self.dateLabel.text = value.data?.createdAt
        self.dismissHUD()
      }, onError: { error in
        self.dismissHUD()
      })
      .disposed(by: disposeBag)
  }
  
}

//
//  PeopleUpdatePopupVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/02.
//

import Foundation
import UIKit

protocol tapModifyProtocol{
  func tapModify(text: String)
}

class PeopleUpdatePopupVC:BaseViewController,ViewControllerFromStoryboard{
  static func viewController() -> PeopleUpdatePopupVC {
    let viewController = PeopleUpdatePopupVC.viewController(storyBoardName: "Manage")
    return viewController
  }
  @IBOutlet weak var tapModify: UIButton!
  @IBOutlet weak var peopleTextField: UITextField!
  
  var delegate: tapModifyProtocol?
  
  override func viewDidLoad() {
    initrx()
  }
  
  func initrx(){
    tapModify.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        if self.peopleTextField.text == ""{
          self.callOkActionMSGDialog(message: "인원을 입력해주세요.") {
          }
          return
        }
        self.delegate?.tapModify(text: self.peopleTextField.text!)
        self.backPress()
      })
      .disposed(by: disposeBag)
  }
  
}

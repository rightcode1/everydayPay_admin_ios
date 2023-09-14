//
//  CommunityDetailMenuPopupVC.swift
//  PlayAround
//
//  Created by 이남기 on 2022/07/13.
//

import Foundation
import UIKit
import RxSwift

protocol MenuDelegate {
  func outRoom()
  
  func joinUserRoom()
  
  func outUserRoom()
  
}

class MoreButtonPopupView: BaseViewController, ViewControllerFromStoryboard {
  
  @IBOutlet weak var outRoomView: UIView!
  @IBOutlet weak var joinUserRoomView: UIView!
  @IBOutlet weak var outUserRoomView: UIView!
  
  @IBOutlet weak var outRoomButton: UIButton!
  @IBOutlet weak var joinUserRoomButton: UIButton!
  @IBOutlet weak var outUserRoomButton: UIButton!
  
  
  var delegate: MenuDelegate?
  let isMine = BehaviorSubject<Bool>(value: false)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindInput()
    bindOutput()
  }
  
  static func viewController() -> MoreButtonPopupView {
    let viewController = MoreButtonPopupView.viewController(storyBoardName: "Common")
    return viewController
  }
  
  func bindInput() {
    outRoomButton.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.backPress()
        self.delegate?.outRoom()
      })
      .disposed(by: disposeBag)
    
    joinUserRoomButton.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.backPress()
        self.delegate?.joinUserRoom()
      })
      .disposed(by: disposeBag)
    
    outUserRoomButton.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.backPress()
        self.delegate?.outUserRoom()
      })
      .disposed(by: disposeBag)
  }
  
  func bindOutput() {
    isMine
      .bind(onNext: { [weak self] isMine in
        guard let self = self else { return }
        self.outUserRoomView.isHidden = !isMine
      })
      .disposed(by: disposeBag)
  }
  
}

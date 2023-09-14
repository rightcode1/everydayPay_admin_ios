//
//  ManageNoticeRegistVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/16.
//

import Foundation
import UIKit

class ManageNoticeRegistVC:BaseViewController,ViewControllerFromStoryboard{
  static func viewController() -> ManageNoticeRegistVC {
    let viewController = ManageNoticeRegistVC.viewController(storyBoardName: "Manage")
    return viewController
  }
    
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var addFileButton: UIImageView!
    
    var id: Int = -1
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
      initrx()
    }
    
    func initrx(){
      addFileButton.rx.tapGesture().when(.recognized)
        .bind(onNext: { [weak self] _ in
          guard let self = self else { return }
          self.showImagePicker(from: self,maxSelectableCount: 1) { selectedImage in
            self.addFileButton.image = selectedImage.first
          }
        })
        .disposed(by: disposeBag)
      registButton.rx.tapGesture().when(.recognized)
          .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            if self.titleTextView.text == nil{
              self.callMSGDialog(message: "채팅방 이름을 입력해주세요.")
              return
            }
            if self.contentTextView.text == nil{
              self.callMSGDialog(message: "내용을 입력해주세요.")
              return
            }
            self.registChat()
          })
          .disposed(by: disposeBag)
    }
    func registChat() {
      APIProvider.shared.manageAPI.rx.request(.noticeRegist(param: NoticeRegistRequest(jobId: id, title: titleTextView.text!, content: contentTextView.text!)))
            .filterSuccessfulStatusCodes()
            .map(DefaultResponse.self)
            .subscribe(onSuccess: { value in
              self.backPress()
            }, onError: { error in
            })
            .disposed(by: disposeBag)
    }
  }


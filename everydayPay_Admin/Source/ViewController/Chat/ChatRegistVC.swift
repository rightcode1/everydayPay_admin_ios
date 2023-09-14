//
//  ChatRegistVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/13.
//

import Foundation
import UIKit
import Photos
import DKImagePickerController

class ChatRegistVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ChatRegistVC {
    let viewController = ChatRegistVC.viewController(storyBoardName: "Chat")
    return viewController
  }
  
  @IBOutlet weak var inputTextView: UITextField!
  @IBOutlet weak var registButton: UIButton!
  @IBOutlet weak var addFileButton: UIImageView!
  
  var diff = "담당자"
  
//  let pickerController = DKImagePickerController()
//  var assets: [DKAsset]?
  var exportManually = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initrx()
  }
  
  func initrx(){
    addFileButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.showImagePicker(from: self,maxSelectableCount: 1) { selectedImage in
//            if let image = selectedImage {
////              self.addFileButton.image = image
//            }
        }
      })
      .disposed(by: disposeBag)
    registButton.rx.tapGesture().when(.recognized)
        .bind(onNext: { [weak self] _ in
          guard let self = self else { return }
          if self.inputTextView.text == nil{
            self.callMSGDialog(message: "채팅방 이름을 입력해주세요.")
            return
          }
//          if self.assets?.count == 0{
//            self.callMSGDialog(message: "채팅방 이미지를 첨부해주세요.")
//            return
//          }
          self.registChat()
        })
        .disposed(by: disposeBag)
  }
  func registChat() {
    APIProvider.shared.chatAPI.rx.request(.regist(param: ChatRegisterRequest(title: inputTextView.text! , diff: diff, userId: DataHelperTool.userId)))
          .filterSuccessfulStatusCodes()
          .map(DefaultIDResponse.self)
          .subscribe(onSuccess: { value in
              let vc = ChatJoinUserVC.viewController()
            vc.diff = self.diff
            vc.controlDiff = true
            vc.roomId = value.data?.id ?? 0
              self.navigationController?.pushViewController(vc, animated: true)
          }, onError: { error in
          })
          .disposed(by: disposeBag)
  }
//  func uploadIamgeList(foodId: Int, success: @escaping () -> Void) {
//    if uploadImages.isEmpty {
//      success()
//    } else {
//      APIProvider.shared.foodAPI.rx.request(.imageRegister(foodId: foodId, imageList: uploadImages.map({ $0 })))
//        .filterSuccessfulStatusCodes()
//        .subscribe(onSuccess: { response in
//          success()
//        }, onError: { error in
//          success()
//        })
//        .disposed(by: disposeBag)
//    }
//  }
}

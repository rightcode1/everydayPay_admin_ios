//
//  InquiryViewController.swift
//  ppuryo
//
//  Created by hoonKim on 2021/05/27.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Photos
import DKImagePickerController


struct InquiryRequest: Codable {
  let title: String
  let content: String
  let email: String
}

class InquiryRegistController: BaseViewController, ViewControllerFromStoryboard {
  
  static func viewController() -> InquiryRegistController {
    let viewController = InquiryRegistController.viewController(storyBoardName: "MyPage")
    return viewController
  }
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var contentTextview: UITextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentTextview.delegate = self
  }
  
  func reRegist() {
    if titleTextField.text!.isEmpty {
      self.callMSGDialog(message: "제목을 입력해주세요.")
    }else if contentTextview.text!.contains("내용을 입력해주세요."){
      self.callMSGDialog(message: "내용을 입력해주세요.")
    }else{
      let param: InqueryRegisterRequest = InqueryRegisterRequest(title: titleTextField.text, content: contentTextview.text)
      APIProvider.shared.inquiryAPI.rx.request(.InqueryRegister(param: param))
        .filterSuccessfulStatusCodes()
        .map(DefaultResponse.self)
        .subscribe(onSuccess: { value in
          if value.statusCode == 200 {
            self.backPress()
            self.dismissHUD()
          } else {
            self.callMSGDialog(message: value.message)
            self.dismissHUD()
          }
          self.dismissHUD()
        }, onError: { error in
          self.dismissHUD()
        })
        .disposed(by: disposeBag)
    }
    
  }
  
  func textViewSetupView() {
    if contentTextview.text == "문의내용을 입력해주세요." {
      contentTextview.text = ""
      contentTextview.textColor = .black
    } else if contentTextview.text.isEmpty {
      contentTextview.text = "문의내용을 입력해주세요."
      contentTextview.textColor = UIColor.lightGray
    }
  }
  
  @IBAction func tapRegister(_ sender: Any) {
    reRegist()
  }
}
extension InquiryRegistController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    textViewSetupView()
    
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if self.contentTextview.text == "" {
      textViewSetupView()
    }
    
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      //                self.inquiryContentTextView.resignFirstResponder()
    }
    return true
  }
}

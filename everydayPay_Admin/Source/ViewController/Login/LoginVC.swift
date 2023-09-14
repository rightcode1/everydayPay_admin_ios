//
//  LoginVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import UIKit

class LoginVC:BaseViewController,ViewControllerFromStoryboard, DialogPopupViewDelegate{
    func dialogOkEvent() {
    }
    
    static func viewController() -> LoginVC {
      let viewController = LoginVC.viewController(storyBoardName: "Login")
      return viewController
    }
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var findIdButton: UILabel!
    @IBOutlet weak var findPwdButton: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initrx()
        
    }
    
    func login() {
        if loginTextField.text == ""{
            callOkActionMSGDialog(message: "아이디를 입력해주세요.") {
            }
            return
        }
        if pwdTextField.text == ""{
            callOkActionMSGDialog(message: "비밀번호를 입력해주세요.") {
            }
            return
        }
        let param = LoginRequest(loginId:loginTextField.text!,password:pwdTextField.text!)
      APIProvider.shared.authAPI.rx.request(.login(param: param))
        .filterSuccessfulStatusCodes()
        .map(LoginResponse.self)
        .subscribe(onSuccess: { value in
          DataHelper.set(value.token, forKey: .token)
          DataHelper.set(value.token, forKey: .chatToken)
          DataHelper.set(self.loginTextField.text!, forKey: .userLoginId)
          DataHelper.set(self.pwdTextField.text!, forKey: .userPw)
          DataHelper.set(value.userId, forKey: .userId)
          self.userInfo { userInfoResponse in
            DataHelper.set(userInfoResponse.data.id, forKey: .userId)
            
            self.dismissHUD()
            self.goMain()
          }
        }, onError: { error in
            let Response = APIProvider.shared.getErrorStatusResponse(error)
            self.showDialogPopupView(title: "로그인 불가", content: Response.message, okbutton: "확인", cancelbutton: nil)
        })
        .disposed(by: disposeBag)
    }
    func initrx(){
        findIdButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                let vc = FindIdVC.viewController()
                self.navigationController?.pushViewController(vc, animated: true)
          })
          .disposed(by: disposeBag)
        findPwdButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                let vc = FindPwdVC.viewController()
                self.navigationController?.pushViewController(vc, animated: true)
          })
          .disposed(by: disposeBag)
        joinButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                let vc = JoinCompanyListVC.viewController()
                self.navigationController?.pushViewController(vc, animated: true)
          })
          .disposed(by: disposeBag)
        loginButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                self.login()
          })
          .disposed(by: disposeBag)
        
    }
    
    @objc func showDialogPopupView(title:String , content:String, okbutton:String, cancelbutton:String?) {
      let vc = DialogPopupView()
      vc.modalPresentationStyle = .custom
      vc.transitioningDelegate = self
      vc.delegate = self
      vc.titleString = title
      vc.contentString = content
      vc.okbuttonTitle = okbutton
      vc.cancelButtonTitle = cancelbutton
      self.present(vc, animated: true, completion: nil)
    }
    
}

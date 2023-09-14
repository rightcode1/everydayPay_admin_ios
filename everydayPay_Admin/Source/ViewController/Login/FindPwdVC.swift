//
//  FindPwdVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import UIKit

class FindPwdVC:BaseViewController,ViewControllerFromStoryboard{
    static func viewController() -> FindPwdVC {
      let viewController = FindPwdVC.viewController(storyBoardName: "Login")
      return viewController
    }
    
    @IBOutlet weak var loginIdField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var authTextField: UITextField!
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var authCountLabel: UILabel!
    @IBOutlet weak var authLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var idcheckImageView: UIImageView!
    
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var isAuth = false
    var oneTimeCodeTimer: Timer?
    var oneTimeCodeCheckCount: Int = 180 {
      didSet {
        let min = oneTimeCodeCheckCount / 60
        let sec = oneTimeCodeCheckCount - (min * 60)
        let countText = "0\(min):\(sec < 10 ? "0" : "")\(sec)"
        print("countText: \(countText)")
          authCountLabel.text = "\(countText)"
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initrx()
    }
    
    @objc
    func countDown() {
      oneTimeCodeCheckCount -= 1
      
      if oneTimeCodeCheckCount <= 0 {
        oneTimeCodeTimer?.invalidate()
        oneTimeCodeTimer = nil
      }
    }
    func startTimer() {
      oneTimeCodeCheckCount = 180
      oneTimeCodeTimer?.invalidate()
      oneTimeCodeTimer = nil
      
      oneTimeCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    func existId() {
        APIProvider.shared.authAPI.rx.request(.existLoginId(loginId: loginIdField.text!))
        .filterSuccessfulStatusCodes()
        .map(DefaultResponse.self)
        .subscribe(onSuccess: { value in
            if value.statusCode == 200{
                self.idLabel.textColor = #colorLiteral(red: 0.5230273604, green: 0.848743856, blue: 0.003915628884, alpha: 1)
                self.idcheckImageView.image = UIImage(named: "joinCheck")
                self.idLabel.text = "이메일이 존재합니다."
            }else{
                self.idLabel.textColor = .red
                self.idcheckImageView.image = UIImage(named: "joinError")
                self.idLabel.text = "이메일이 존재하지않습니다."
            }
        }, onError: { error in
        })
        .disposed(by: disposeBag)
    }
    
    func sendAuth() {
        APIProvider.shared.authAPI.rx.request(.certificationNumberSMS(tel: phoneTextField.text!, diff: .find))
        .filterSuccessfulStatusCodes()
        .map(DefaultResponse.self)
        .subscribe(onSuccess: { value in
            self.startTimer()
        }, onError: { error in
        })
        .disposed(by: disposeBag)
    }
    
    func authCheck(authNumber: String) {
        checkImageView.isHidden = false
        authLabel.isHidden = false
        APIProvider.shared.authAPI.rx.request(.confirm(tel: phoneTextField.text!, confirm: authNumber))
        .filterSuccessfulStatusCodes()
        .map(DefaultResponse.self)
        .subscribe(onSuccess: { value in
            self.isAuth = true
            self.authLabel.textColor = #colorLiteral(red: 0.5230273604, green: 0.848743856, blue: 0.003915628884, alpha: 1)
            self.authCountLabel.textColor = #colorLiteral(red: 0.5230273604, green: 0.848743856, blue: 0.003915628884, alpha: 1)
            self.checkImageView.image = UIImage(named: "joinCheck")
            self.authLabel.text = "인증이 완료되었습니다."
        }, onError: { error in
            self.authLabel.textColor = .red
            self.authCountLabel.textColor = .red
            self.checkImageView.image = UIImage(named: "joinError")
            self.authLabel.text = "인증번호가 틀렸습니다!"
        })
        .disposed(by: disposeBag)
    }
    
    func initrx(){
        loginIdField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.existId()
            })
            .disposed(by: disposeBag)
        phoneTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                if changedText.count == 11{
                    self.authButton.backgroundColor = #colorLiteral(red: 0.9511640668, green: 0.4395188689, blue: 0.1397989094, alpha: 1)
                    self.authButton.titleLabel?.textColor = .white
                }else{
                    self.authButton.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
                    self.authButton.titleLabel?.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
                }
            })
            .disposed(by: disposeBag)
        
        authTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.authCheck(authNumber: changedText)
            })
            .disposed(by: disposeBag)
        
        authButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                if self.phoneTextField.text?.count != 11{
                    self.callOkActionMSGDialog(message: "올바른 전화번호를 입력해주세요.") {
                    }
                    return
                }
                self.authView.isHidden = false
                self.authButton.titleLabel?.textColor = .white
                self.sendAuth()
          })
          .disposed(by: disposeBag)
        
        nextButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                if !self.isAuth{
                    self.callOkActionMSGDialog(message: "인증을 완료해주세요.") {
                    }
                    return
                }
                let vc = FindPwd2VC.viewController()
                vc.tel = self.phoneTextField.text!
                vc.id = self.loginIdField.text!
                self.navigationController?.pushViewController(vc, animated: true)
          })
          .disposed(by: disposeBag)
    }
}

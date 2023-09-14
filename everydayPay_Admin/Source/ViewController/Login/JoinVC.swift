//
//  JoinVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import UIKit
import DropDown

class JoinVC:BaseViewController,ViewControllerFromStoryboard{
    static func viewController() -> JoinVC {
        let viewController = JoinVC.viewController(storyBoardName: "Login")
        return viewController
    }
    
    @IBOutlet weak var companyNameStackView: UIView!
    @IBOutlet weak var ceoNameStackView: UIView!
    @IBOutlet weak var companyThemeStackView: UIView!
    @IBOutlet weak var companyCategoryStackView: UIView!
    @IBOutlet weak var companyNumStackView: UIView!
    @IBOutlet weak var companyPhoneStackView: UIView!
    
    @IBOutlet weak var authStackView: UIView!
    @IBOutlet weak var authTextField: UITextField!
    @IBOutlet weak var authCountLabel: UILabel!
    @IBOutlet weak var authCheckImageView: UIImageView!
    @IBOutlet weak var authLabel: UILabel!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loginIdTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdOkTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var ceoNameTextField: UITextField!
    @IBOutlet weak var companyThemeTextField: UITextField! // 업태
    @IBOutlet weak var companyCategoryTextField: UITextField! // 종목
    @IBOutlet weak var companyNumTextField: UITextField! // 사업자 등록번호
    @IBOutlet weak var companyPhoneTextField: UITextField! // 업체 전화번호
    
    @IBOutlet weak var phoneAgencyDropDownView: UIView!
    @IBOutlet weak var phoneAgencyLabel: UILabel!
    
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var privacyAgreeButton: UIView!
    @IBOutlet weak var useAgreeButton: UIView!
    @IBOutlet weak var privacyAgreeCheckButton: UIImageView!
    @IBOutlet weak var useAgreeCheckButton: UIImageView!
    
    
    
    var selectCompanyId: Int = -1
    var selectCompnayName: String = ""
    var isNewCompany : Bool = false
    var isPhoneAuth : Bool = false
    var isPrivacyAgree : Bool = false{
        didSet{
            privacyAgreeCheckButton.image = isPrivacyAgree ? UIImage(named: "check_off") : UIImage(named: "check_on")
        }
    }
    var isUserAgree : Bool = false{
        didSet{
            useAgreeCheckButton.image = isUserAgree ? UIImage(named: "check_off") : UIImage(named: "check_on")
        }
    }
    
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
    
    let dropDown = DropDown()
    
    
    override func viewWillAppear(_ animated: Bool) {
        isNewCompanyUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDropDown()
        initrx()
        
    }
    func isNewCompanyUI(){
        companyNameStackView.isHidden = !isNewCompany
        ceoNameStackView.isHidden = !isNewCompany
        companyThemeStackView.isHidden = !isNewCompany
        companyCategoryStackView.isHidden = !isNewCompany
        companyNumStackView.isHidden = !isNewCompany
        companyPhoneStackView.isHidden = !isNewCompany
    }
    func initDropDown(){
        
        let agencyList : [String] = ["선택","SKT","KT","LGU+"]
        
        self.dropDown.dataSource = agencyList
        self.dropDown.anchorView = self.phoneAgencyDropDownView
        self.dropDown.backgroundColor = .white
        self.dropDown.direction = .bottom
        
        self.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            if index == 0{
                self.phoneAgencyLabel.text = item
                self.phoneAgencyLabel.textColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.8, alpha: 1)
            }else{
                self.phoneAgencyLabel.text = item
                self.phoneAgencyLabel.textColor = .black
            }
        }
        self.dropDown.reloadAllComponents()
        
        phoneAgencyDropDownView.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dropDown.show()
            })
            .disposed(by: disposeBag)
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
        authStackView.isHidden = false
        oneTimeCodeCheckCount = 180
        oneTimeCodeTimer?.invalidate()
        oneTimeCodeTimer = nil
        
        oneTimeCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func sendAuth() {
        APIProvider.shared.authAPI.rx.request(.certificationNumberSMS(tel: phoneTextField.text!, diff: .join))
            .filterSuccessfulStatusCodes()
            .map(DefaultResponse.self)
            .subscribe(onSuccess: { value in
                self.startTimer()
            }, onError: { error in
            })
            .disposed(by: disposeBag)
    }
    
    func authCheck(authNumber: String) {
        authCheckImageView.isHidden = false
        authLabel.isHidden = false
        APIProvider.shared.authAPI.rx.request(.confirm(tel: phoneTextField.text!, confirm: authNumber))
            .filterSuccessfulStatusCodes()
            .map(DefaultResponse.self)
            .subscribe(onSuccess: { value in
                self.isPhoneAuth = true
                self.authLabel.textColor = #colorLiteral(red: 0.5230273604, green: 0.848743856, blue: 0.003915628884, alpha: 1)
                self.authCountLabel.textColor = #colorLiteral(red: 0.5230273604, green: 0.848743856, blue: 0.003915628884, alpha: 1)
                self.authCheckImageView.image = UIImage(named: "joinCheck")
                self.authLabel.text = "인증이 완료되었습니다."
            }, onError: { error in
                self.isPhoneAuth = false
                self.authLabel.textColor = .red
                self.authCountLabel.textColor = .red
                self.authCheckImageView.image = UIImage(named: "joinError")
                self.authLabel.text = "인증번호가 틀렸습니다!"
            })
            .disposed(by: disposeBag)
    }
    
    func existCompanyRegister() {
        if userNameTextField.text == ""{
            callOkActionMSGDialog(message: "이름을 입력해주세요.") {
            }
            return
        }
        if loginIdTextField.text == ""{
            callOkActionMSGDialog(message: "아이디를 입력해주세요.") {
            }
            return
        }
        if pwdTextField.text == ""{
            callOkActionMSGDialog(message: "비밀번호를 입력해주세요.") {
            }
            return
        }
        if pwdTextField.text != pwdOkTextField.text{
            callOkActionMSGDialog(message: "비밀번호가 일치하지 않습니다.") {
            }
            return
        }
        if phoneAgencyLabel.text == "통신사를 선택해주세요." || phoneAgencyLabel.text == "선택"{
            callOkActionMSGDialog(message: "통신사를 선택해주세요.") {
            }
            return
        }
        if phoneTextField.text == ""{
            callOkActionMSGDialog(message: "전화번호를 입력해주세요.") {
            }
            return
        }
        if !isPhoneAuth{
            callOkActionMSGDialog(message: "전화번호 인증을 진행해주세요.") {
            }
            return
        }
        
        let param = UserRegisterRequest(loginId: loginIdTextField.text!, password: pwdTextField.text!, newsAgency: phoneAgencyLabel.text!, tel: phoneTextField.text!, name: userNameTextField.text!, companyId: selectCompanyId)
        APIProvider.shared.userAPI.rx.request(.userRegister(param: param))
            .filterSuccessfulStatusCodes()
            .map(DefaultResponse.self)
            .subscribe(onSuccess: { value in
                self.callOkActionMSGDialog(message: "회원가입 완료되었습니다.") {
                    self.rootBackPress()
                }
            }, onError: { error in
            })
            .disposed(by: disposeBag)
    }
    
    
    func initrx(){
        
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
                print("text:\(changedText)")
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
                self.authButton.titleLabel?.textColor = .white
                self.authStackView.isHidden = false
                self.sendAuth()
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.isNewCompany{
                }else{
                    self.existCompanyRegister()
                }
            })
            .disposed(by: disposeBag)
        
        privacyAgreeButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
            })
            .disposed(by: disposeBag)
        
        useAgreeButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
            })
            .disposed(by: disposeBag)
        
        privacyAgreeCheckButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isPrivacyAgree = !self.isPrivacyAgree
            })
            .disposed(by: disposeBag)
        
        useAgreeCheckButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isUserAgree = !self.isUserAgree
            })
            .disposed(by: disposeBag)
    }
    
}

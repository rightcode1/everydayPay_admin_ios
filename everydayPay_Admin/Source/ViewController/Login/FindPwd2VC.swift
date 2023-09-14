//
//  FindPwd2VC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import UIKit

class FindPwd2VC:BaseViewController,ViewControllerFromStoryboard{
    static func viewController() -> FindPwd2VC {
        let viewController = FindPwd2VC.viewController(storyBoardName: "Login")
        return viewController
    }
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var pwdTextOkField: UITextField!
    @IBOutlet weak var pwdCheckImageView: UIImageView!
    @IBOutlet weak var pwdLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var tel: String?
    var id: String?
    var isOk: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initrx()
        
    }
    func existId() {
        if pwdTextField.text! != pwdTextOkField.text!{
            self.callOkActionMSGDialog(message: "비밀번호를 확인해주세요.") {
            }
            return
        }
        
        let param = PasswordChangeRequest(tel: tel!, loginId: id!, password: pwdTextField.text!)
        APIProvider.shared.authAPI.rx.request(.passwordChange(param: param))
            .filterSuccessfulStatusCodes()
            .map(DefaultResponse.self)
            .subscribe(onSuccess: { value in
                self.isOk = true
            }, onError: { error in
            })
            .disposed(by: disposeBag)
    }
    func initrx(){
        //        pwdTextField.rx.text
        //            .orEmpty
        //            .distinctUntilChanged()
        //            .subscribe(onNext: { changedText in
        //                self.existId()
        //            })
        //            .disposed(by: disposeBag)
        pwdTextOkField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                if self.pwdTextField.text! != self.pwdTextOkField.text!{
                    self.pwdLabel.textColor = .red
                    self.pwdCheckImageView.image = UIImage(named: "joinError")
                    self.pwdLabel.text = "비밀번호가 틀렸어요"
                    self.isOk = false
                }else{
                    self.pwdLabel.textColor = #colorLiteral(red: 0.5230273604, green: 0.848743856, blue: 0.003915628884, alpha: 1)
                    self.pwdCheckImageView.image = UIImage(named: "joinCheck")
                    self.pwdLabel.text = "비밀번호가 일치해요"
                    self.isOk = true
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                if !self.isOk{
                    self.callOkActionMSGDialog(message: "비밀번호를 확인해주세요.") {
                    }
                    return
                }
                
                let vc = FindPwdOkVC.viewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

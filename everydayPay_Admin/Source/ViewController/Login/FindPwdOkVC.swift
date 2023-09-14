//
//  FindPwdOkVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import UIKit

class FindPwdOkVC:BaseViewController,ViewControllerFromStoryboard{
    static func viewController() -> FindPwdOkVC {
      let viewController = FindPwdOkVC.viewController(storyBoardName: "Login")
      return viewController
    }
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initrx()
    }
    
    func initrx(){
        
        loginButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.rootBackPress()
            })
            .disposed(by: disposeBag)
    }
}

//
//  FindIdOkVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import UIKit

class FindIdOkVC:BaseViewController,ViewControllerFromStoryboard{
    static func viewController() -> FindIdOkVC {
      let viewController = FindIdOkVC.viewController(storyBoardName: "Login")
      return viewController
    }
    
    @IBOutlet weak var idLabel: UILabel!
    var tel: String?
    
    override func viewWillAppear(_ animated: Bool) {
        findId()
    }
    func findId() {
        APIProvider.shared.authAPI.rx.request(.findLoginId(tel: tel ?? ""))
        .filterSuccessfulStatusCodes()
        .map(FindIDResponse.self)
        .subscribe(onSuccess: { value in
            self.idLabel.text = value.data?.loginId
        }, onError: { error in
        })
        .disposed(by: disposeBag)
    }
}

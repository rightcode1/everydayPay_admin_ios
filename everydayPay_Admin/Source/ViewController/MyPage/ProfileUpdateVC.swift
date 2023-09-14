//
//  ProfileUpdateVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/24.
//

import Foundation
import UIKit

class ProfileUpdateVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ProfileUpdateVC {
    let viewController = ProfileUpdateVC.viewController(storyBoardName: "MyPage")
    return viewController
  }
  @IBOutlet weak var userProfileImageView: UIImageView!
  @IBOutlet weak var loginIdTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var changePasswordLabel: UILabel!
  @IBOutlet weak var logoutLabel: UILabel!
  @IBOutlet weak var userOutLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = true
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    userInfo { value in
      if value.data.thumbnail != nil{
        self.userProfileImageView.kf.setImage(with: URL(string: value.data.thumbnail ?? ""))
      }else{
        self.userProfileImageView.image = UIImage(named: "profile")
      }
      self.loginIdTextField.text = value.data.loginId
      self.nameTextField.text = value.data.name
    }
    initrx()
    
  }
  func initrx(){
    changePasswordLabel.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
      })
      .disposed(by: disposeBag)
    logoutLabel.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
      })
      .disposed(by: disposeBag)
    userOutLabel.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = JoinCompanyListVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    userProfileImageView.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.showImagePicker(from: self,maxSelectableCount: 1) { selectedImage in
//            if let image = selectedImage {
                self.userProfileImageView.image = selectedImage[0]
//            }
        }
      })
      .disposed(by: disposeBag)
    
  }
  
}

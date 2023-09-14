//
//  MyPageVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/24.
//

import Foundation
import UIKit

class MyPageVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> MyPageVC {
    let viewController = MyPageVC.viewController(storyBoardName: "MyPage")
    return viewController
  }
  @IBOutlet weak var userProfileImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userCompanyName: UILabel!
  
  @IBOutlet weak var userProfileView: UIView!
  @IBOutlet weak var userGuideView: UIView!
  @IBOutlet weak var inquiryView: UIView!
  @IBOutlet weak var noticeView: UIView!
  @IBOutlet weak var questionView: UIView!
  
  override func viewWillAppear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = false
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    userInfo { value in
      if value.data.thumbnail != nil{
        self.userProfileImageView.kf.setImage(with: URL(string: value.data.thumbnail ?? ""))
      }else{
        self.userProfileImageView.image = UIImage(named: "profile")
      }
      self.userNameLabel.text = value.data.name
      self.userCompanyName.text = value.data.companyName
    }
    initrx()
    
  }
  func initrx(){
    userProfileView.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = ProfileUpdateVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    userGuideView.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = GuideVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    inquiryView.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = InquiryListVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    noticeView.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = NoticeListViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    questionView.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = FAQVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    
  }
  
}

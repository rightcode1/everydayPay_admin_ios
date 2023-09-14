//
//  ManageListCell.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol tapManageProtocol{
  func tapApplicant(id: Int)
  func tapAttendance(id: Int)
  func tapNotice(id: Int)
}

class ManageListCell: UITableViewCell{
  @IBOutlet weak var activeStatusLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var averageLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var siteNamgeLabel: UILabel!
  @IBOutlet weak var createLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var applicantMangeButton: UIButton!
  @IBOutlet weak var attendanceButton: UIButton!
  @IBOutlet weak var noticeButton: UIButton!
  
  var delegate: tapManageProtocol?
  var manageData: ManageData?
  var disposeBag = DisposeBag()
  
  func initupdate(data: ManageData){
    manageData = data
    initrx()
    activeStatusLabel.text = data.active ? "승인완료" : "승인대기"
    activeStatusLabel.textColor = data.active ? #colorLiteral(red: 0.5230273604, green: 0.848743856, blue: 0.003915628884, alpha: 1) : .red
    addressLabel.text = data.address
    //    averageLabel.text = ""
    titleLabel.text = data.companyName
    siteNamgeLabel.text = data.siteName
    createLabel.text = data.createdAt
    categoryLabel.text = data.category
    attendanceButton.isHidden = data.category == "건설" ? true : false
  }
  
  func initrx(){
    applicantMangeButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.tapApplicant(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
    attendanceButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.tapAttendance(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
    noticeButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.tapNotice(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
  }
  
}

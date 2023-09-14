//
//  SupportListCell.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/01.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol tapSupportProtocol{
  func tapBye(id: Int)
  func tapReview(id: Int)
}

class SupportListCell: UITableViewCell{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var diffLabel: UILabel!
  @IBOutlet weak var averageLabel: UILabel!
  @IBOutlet weak var birthLabel: UILabel!
  @IBOutlet weak var payLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  
  @IBOutlet weak var tapReview: UIImageView!
  @IBOutlet weak var tapCancelButton: UIButton!
  
  var delegate: tapSupportProtocol?
  var manageData: ManageSupportData?
  var disposeBag = DisposeBag()
  
  func initupdate(data: ManageSupportData){
    manageData = data
    initrx()
    nameLabel.text = data.user.name
    diffLabel.text = data.user.diff
    averageLabel.text = "\(Double(data.user.averageRate))"
//    ageLabel.text = data.use
    birthLabel.text = data.user.birth
    payLabel.text = "\(data.user.pay) 만원"
//    categoryLabel.text = data.category
  }
  
  func initrx(){
    tapCancelButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.tapBye(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
    tapReview.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.tapReview(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
  }
  
}

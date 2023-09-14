//
//  ErectionSupportListCell.swift.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/02.
//

import Foundation


import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol tapErectionSupportProtocol{
  func tapBye(id: Int)
  func tapReview(id: Int)
}

class ErectionSupportListCell: UITableViewCell{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var diffLabel: UILabel!
  @IBOutlet weak var averageLabel: UILabel!
  @IBOutlet weak var birthLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var completeCheckLabel: UILabel!
  @IBOutlet weak var certCheckLabel: UILabel!
  
  
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
    birthLabel.text = data.user.birth
    completeCheckLabel.text = data.user.isComplete ? "인증완료" : "미인증"
    certCheckLabel.text = data.user.isCert ? "인증완료" : "미인증"
    
    
    completeCheckLabel.textColor = data.user.isComplete ? .green : .red
    certCheckLabel.textColor = data.user.isCert ? .green : .red
  }
  
  func initrx(){
    tapCancelButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.tapBye(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
  }
  
}

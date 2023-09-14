//
//  AttendanceListCell.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/02.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import DropDown

protocol tapAttendanceProtocol{
  func tapStart(id: Int)
  func tapEnd(id: Int)
  func tapAttendanceReview(id: Int)
  func tapGongsu(id: Int,Gongsu:String)
}

class AttendanceListCell: UITableViewCell{
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var diffLabel: UILabel!
  @IBOutlet weak var birthLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  
  @IBOutlet weak var startTime: UILabel!
  @IBOutlet weak var endTime: UILabel!
  @IBOutlet weak var defaultGongSuLabel: UILabel!
  
  @IBOutlet weak var gongSuDropView: UIView!
  @IBOutlet weak var gongSuLabel: UILabel!
  
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var endButton: UIButton!
  @IBOutlet weak var reviewButton: UIButton!
  
  var delegate: tapAttendanceProtocol?
  var manageData: ManageSupportData?
  var disposeBag = DisposeBag()
  let dropDown = DropDown()
  
  func initupdate(data: ManageSupportData){
    manageData = data
    initrx()
    nameLabel.text = data.user.name
    diffLabel.text = data.user.diff
    birthLabel.text = data.user.birth
    defaultGongSuLabel.text = data.customWorkCount != nil ? "\(data.customWorkCount!)" : "-"
    startTime.text = data.startHour != nil ? data.startHour : "--:--"
    endTime.text = data.endHour != nil ? data.endHour : "--:--"
    if manageData?.review != nil{
      ButtonOnReview()
      Buttonff(button: endButton)
      Buttonff(button: startButton)
    }else if manageData?.endHour != nil{
      Buttonff(button: reviewButton)
      ButtonOnEnd()
      Buttonff(button: startButton)
    }else{
      Buttonff(button: reviewButton)
      Buttonff(button: endButton)
      ButtonOnStart()
    }
    initDropDown()
  }
  func Buttonff(button:UIButton){
    button.backgroundColor = .white
    button.borderColor = #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1)
    button.titleLabel?.textColor = #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1)
  }
  func ButtonOnReview(){
    reviewButton.backgroundColor = manageData?.review == nil ? .white : #colorLiteral(red: 0.9511640668, green: 0.4395188689, blue: 0.1397989094, alpha: 1)
    reviewButton.borderColor = manageData?.review == nil ?  #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1) : .clear
    reviewButton.titleLabel?.textColor = manageData?.review == nil ? #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1) : .white
  }
  func ButtonOnEnd(){
    endButton.backgroundColor = manageData?.endHour == nil ? .white : #colorLiteral(red: 0.9511640668, green: 0.4395188689, blue: 0.1397989094, alpha: 1)
    endButton.borderColor = manageData?.endHour == nil ?  #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1) : .clear
    endButton.titleLabel?.textColor = manageData?.endHour == nil ? #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1) : .white
  }
  func ButtonOnStart(){
    startButton.backgroundColor = manageData?.startHour == nil ? .white : #colorLiteral(red: 0.9511640668, green: 0.4395188689, blue: 0.1397989094, alpha: 1)
    startButton.borderColor = manageData?.startHour == nil ?  #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1) : .clear
    startButton.titleLabel?.textColor = manageData?.startHour == nil ? #colorLiteral(red: 0.7764706016, green: 0.7764706016, blue: 0.7764706016, alpha: 1) : .white
  }
  func initDropDown(){
    let list : [String] = ["선택","0.0","0.2","0.3","0.5","0.7","1.0","1.3","1.5","2.0"]
    dropDown.dataSource = list
    dropDown.anchorView = gongSuDropView
    dropDown.backgroundColor = .white
    dropDown.direction = .bottom
    dropDown.selectionAction = { [weak self] (index: Int, item: String) in
      guard let self = self else { return }
      self.gongSuLabel.text = item
      if index != 0{
        self.delegate?.tapGongsu(id: self.manageData?.id ?? 0, Gongsu: self.gongSuLabel.text ?? "0.0")
      }
    }
    self.dropDown.reloadAllComponents()
  }
  
  func initrx(){
    startButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.ButtonOnStart()
        self.delegate?.tapStart(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
    endButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.ButtonOnEnd()
        self.delegate?.tapEnd(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
    reviewButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.ButtonOnReview()
        self.delegate?.tapAttendanceReview(id: self.manageData?.id ?? 0)
      })
      .disposed(by: disposeBag)
    gongSuDropView.rx.gesture(.tap()).when(.recognized).subscribe(onNext: { [weak self] _ in
      guard let self = self else { return }
      self.dropDown.show()
    }).disposed(by: disposeBag)
  }
  
}

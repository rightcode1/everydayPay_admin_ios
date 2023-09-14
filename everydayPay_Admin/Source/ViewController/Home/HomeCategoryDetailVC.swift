//
//  HomeCategoryDetailVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/07.
//

import Foundation
import UIKit
import FSCalendar

class HomeCategoryDetailVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> HomeCategoryDetailVC {
    let viewController = HomeCategoryDetailVC.viewController(storyBoardName: "Home")
    return viewController
  }
  
  @IBOutlet weak var mainTableView: UITableView!
  @IBOutlet weak var siteAddButton: UIView!
  
  @IBOutlet weak var extraOtherView: UIView!
  @IBOutlet weak var parkingView: UIView!
  
  @IBOutlet weak var calendarView: FSCalendar!
  
  @IBOutlet weak var workTimeTextField: UITextField!
  @IBOutlet weak var payextField: UITextField!
  @IBOutlet weak var budgetTextField: UITextField!
  @IBOutlet weak var workContentTextField: UITextField!
  @IBOutlet weak var extraOtherTextField: UITextField!
  
  var id : Int = -1
  var isRegist: Bool = false
  var siteList: [SiteList] = []
  var scehdule: [CalendarData] = []
  var selectSite: SiteList?
  var homeCategory: HomeCategory?
  private var selectDate: Date = Date(timeIntervalSinceNow: 86400)
  
  override func viewDidLoad() {
    mainTableView.delegate = self
    mainTableView.dataSource = self
    initrx()
    if isRegist{
      userInfo(result: { result in
        self.initSiteList(result.data.companyId ?? 0)
      })
    }else{
      initDetail()
      initSchedule()
    }
  }
  
  func initSiteList(_ id: Int) {
    APIProvider.shared.manageAPI.rx.request(.siteList(id: id))
      .filterSuccessfulStatusCodes()
      .map(SiteListResponse.self)
      .subscribe(onSuccess: { value in
        let list = value.list.filter{$0.active && $0.category == self.homeCategory!}
        if list.count > 0{
          for count in 0 ..< list.count{
            self.siteList.append(SiteList(address: list[count].address, siteName: list[count].name, companyName:list[count].companyName, createdAt: list[count].createdAt, isSelect: false))
          }
          self.mainTableView.reloadData()
        }
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  func initSchedule() {
    APIProvider.shared.manageAPI.rx.request(.jobDetail(id: id))
      .filterSuccessfulStatusCodes()
      .map(ManageDetailResponse.self)
      .subscribe(onSuccess: { value in
        self.siteList.append(SiteList(address: value.data.address, siteName: value.data.siteName, companyName: value.data.companyName, createdAt: value.data.createdAt, isSelect: true))
        self.scehdule = value.data.jobSchedule
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.calendarView.appearance.subtitleOffset = CGPoint(x: 0, y: 21)
        self.calendarView.appearance.titleOffset = CGPoint(x: 0, y: 7)
        self.calendarView.appearance.subtitleFont = .boldSystemFont(ofSize: 12)
        self.mainTableView.reloadData()
        self.workTimeTextField.text = value.data.workingTime
        self.payextField.text = "\(value.data.pay)"
        self.budgetTextField.text = value.data.charge
        self.workContentTextField.text = value.data.details
        self.extraOtherTextField.text = value.data.etc
        
        self.workTimeTextField.isUserInteractionEnabled = false
        self.payextField.isUserInteractionEnabled = false
        self.budgetTextField.isUserInteractionEnabled = false
        self.workContentTextField.isUserInteractionEnabled = false
        self.extraOtherTextField.isUserInteractionEnabled = false
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  
  func initDetail(){
    navigationController?.title = "일자리내역"
    siteAddButton.isHidden = true
    parkingView.isHidden = true
    extraOtherView.isHidden = true
    mainTableView.layoutTableFooterView()
  }
  
  
  func initrx(){
    siteAddButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = HomeSiteListVC.viewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
      })
      .disposed(by: disposeBag)
  }
//  func setCalenderHeaderDate(date: Date) {
//    let monthDateFormatter = DateFormatter()
//    monthDateFormatter.dateFormat = "yyyy.MM"
////    calenderHeaderLabel.text = monthDateFormatter.string(from: date)
//  }
//
  
  
}
extension HomeCategoryDetailVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return siteList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    guard let backView = cell.viewWithTag(5) as? UIView,
          let addressLabel = cell.viewWithTag(1) as? UILabel,
          let titleLabel = cell.viewWithTag(2) as? UILabel,
          let companyLabel = cell.viewWithTag(3) as? UILabel,
          let createLabel = cell.viewWithTag(4) as? UILabel else {
      return cell
    }
    let dict = siteList[indexPath.row]
    backView.borderColor = dict.isSelect ? .black : #colorLiteral(red: 0.9598991275, green: 0.9648705125, blue: 0.9647826552, alpha: 1)
    addressLabel.text = dict.address
    titleLabel.text = dict.siteName
    companyLabel.text = dict.companyName
    createLabel.text = dict.createdAt
      return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isRegist{
      for count in 0 ..< siteList.count{
        siteList[count].isSelect = false
      }
      siteList[indexPath.row].isSelect = true
      selectSite = siteList[indexPath.row]
      mainTableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
    
  }
  
}

extension HomeCategoryDetailVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
  }
  
  func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    let index = scehdule.firstIndex(where: { $0.date == changeDatetoString(date:date) })
    if scehdule[index ?? 0].people != nil{
        return "\(scehdule[index!].people!)"
      }else{
        return "" // 해당 부분에 nil을 줘버리게 되면은 default일때와 "오늘"일때 날짜 위치가 맞지않음
      }
  }
  
  func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    if calendar.selectedDates.count > 0 {
      return false
    }else{
      return true
    }
  }
  
//  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
//    self.setCalenderHeaderDate(date: calendar.currentPage)
//  }
}
extension HomeCategoryDetailVC: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

          return false

      }
}
extension HomeCategoryDetailVC: siteRegistProtocol{
  func getSiteUpdate() {
    showToast(message: "get list")
  }
}


//
//  ManageApplicantVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/18.
//

import Foundation
import UIKit
import AVFoundation
import FSCalendar


class ManageDetailVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ManageDetailVC {
    let viewController = ManageDetailVC.viewController(storyBoardName: "Manage")
    return viewController
  }
  @IBOutlet weak var mainTableView: UITableView!
  
  @IBOutlet weak var totalPeopleCountLabel: UILabel!
  @IBOutlet weak var currentPeopleCountLabel: UILabel!
  
  @IBOutlet weak var calenderHeaderLabel: UILabel!
  @IBOutlet weak var previousButton: UIImageView!
  @IBOutlet weak var nextButton: UIImageView!
  @IBOutlet weak var peopleModifyButton: UIView!
  
  @IBOutlet weak var calendarView: FSCalendar!
  @IBOutlet weak var noSelectCalendarHiddenView: UIView!
  
  private var selectDate: Date = Date(timeIntervalSinceNow: 86400)
  var id: Int = -1
  var isApplicant: Bool = false
  var isAttendance: Bool = false
  var supportUserList: [ManageSupportData] = []{
    didSet{
      mainTableView.reloadData()
    }
  }
  var scehdule: [CalendarList] = []
  
  
  override func viewDidLoad() {
    initrx()
    self.hiddenNoSchedule(isSchedul: true)
    setCalenderHeaderDate(date: selectDate)
    initdelegate()
  }
  func initdelegate(){
    calendarView.delegate = self
    calendarView.dataSource = self
    calendarView.appearance.subtitleOffset = CGPoint(x: 0, y: 21)
    calendarView.appearance.titleOffset = CGPoint(x: 0, y: 7)
    calendarView.appearance.subtitleFont = .boldSystemFont(ofSize: 12)
    //    calendarView.scrollEnabled = false
    
    mainTableView.delegate = self
    mainTableView.dataSource = self
    
  }
  
  func setCalenderHeaderDate(date: Date) {
    let monthDateFormatter = DateFormatter()
    monthDateFormatter.dateFormat = "yyyy.MM"
    calenderHeaderLabel.text = monthDateFormatter.string(from: date)
    initCalendar()
  }
  
  
  func getNextMonth(date:Date)->Date {
    return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
  }
  
  func getPreviousMonth(date:Date)->Date {
    return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
  }
  
  func initCalendar() {
    let param = CalendarRequest(jobId: 24,date: changeDatetoMonthString(date: self.calendarView.currentPage))
    APIProvider.shared.manageAPI.rx.request(.calendarList(param: param))
      .filterSuccessfulStatusCodes()
      .map(CalendarListResponse.self)
      .subscribe(onSuccess: { value in
        self.scehdule = value.list
        self.calendarView.reloadData()
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  func initSupportUserList(index: Int?) {
    if index != nil{
      totalPeopleCountLabel.text = "\(scehdule[index ?? 0].count ?? 0)명 신청"
      currentPeopleCountLabel.text = "\(scehdule[index ?? 0].supportCount)명 구인중"
    }
    let param = CalendarRequest(jobId: 24,date: changeDatetoString(date: self.selectDate))
    APIProvider.shared.manageAPI.rx.request(.supportList(param: param))
      .filterSuccessfulStatusCodes()
      .map(ManageSupportListResponse.self)
      .subscribe(onSuccess: { value in
        print("!!")
        self.supportUserList = value.list
        self.dismissHUD()
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  
  func updateSupport(id: Int,status:SupportUpdate,gognsu: Double?) {
    let param = SupportUpdateRequest(status: status, customWorkCount: gognsu)
    APIProvider.shared.manageAPI.rx.request(.supportUpdate(id: id, param: param))
      .filterSuccessfulStatusCodes()
      .map(DefaultResponse.self)
      .subscribe(onSuccess: { value in
        self.initSupportUserList(index: nil)
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  func initrx(){
    previousButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.calendarView.setCurrentPage(self.getPreviousMonth(date: self.calendarView.currentPage), animated: true)
      })
      .disposed(by: disposeBag)
    nextButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.calendarView.setCurrentPage(self.getNextMonth(date: self.calendarView.currentPage), animated: true)
        
      })
      .disposed(by: disposeBag)
    peopleModifyButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = PeopleUpdatePopupVC.viewController()
        vc.delegate = self
        self.present(vc, animated: true)
        
      })
      .disposed(by: disposeBag)
  }
  func hiddenNoSchedule(isSchedul: Bool){
    self.noSelectCalendarHiddenView.isHidden = isSchedul
    self.mainTableView.layoutTableHeaderView()
  }
  
}
extension ManageDetailVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return supportUserList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dict = supportUserList[indexPath.row]
    if isApplicant && dict.category != "건설"{
      let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "Applicant cell", for: indexPath) as! SupportListCell
      cell.delegate = self
      cell.initupdate(data: dict)
      return cell
    }else if isAttendance{
      let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "Attendance cell1", for: indexPath) as! AttendanceListCell
      cell.delegate = self
      cell.initupdate(data: dict)
      return cell
    }else{
      let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "Attendance cell 2", for: indexPath) as! ErectionSupportListCell
      cell.delegate = self
      cell.initupdate(data: dict)
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
    
  }
  
}

extension ManageDetailVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
  
//  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int { //점찍는 부분
//    if self.dates.contains(date){
//      return 1
//    }
//    return 0
//  }
  
  
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    selectDate = date
    var dates: [Date] = []
    let supportTrues = scehdule.filter{$0.isSupport} // list 중 isSupoort가 true 인것들만 따로 뽑아내주는 부분
    dates = supportTrues.map({self.chageStringtoDate(date: $0.date)}) // value.list 중 키 이름이 date인것만 빼서 chageStringtoDate를 사용해 [Date]형식으로 삽입시켜줌
    if dates.contains(date){
      self.showHUD()
      self.hiddenNoSchedule(isSchedul: false)
      let index = scehdule.firstIndex(where: { $0.date == changeDatetoString(date:date) }) ?? 0
      self.initSupportUserList(index: index)
    }else{
      self.hiddenNoSchedule(isSchedul: true)
      supportUserList.removeAll()
    }
  }
  
  func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    let index = scehdule.firstIndex(where: { $0.date == changeDatetoString(date:date) })
    if scehdule[index ?? 0].count != nil{
      return "\(scehdule[index!].supportCount)/\(scehdule[index!].count ?? 0)"
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
  
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    self.setCalenderHeaderDate(date: calendar.currentPage)
  }
}


extension ManageDetailVC: tapSupportProtocol,tapModifyProtocol,tapAttendanceProtocol,tapErectionSupportProtocol{
  
  func tapReview(id: Int) {
  }
  
  func tapBye(id: Int) {
    updateSupport(id: id, status: .cancel, gognsu: nil)
  }
  
  
  
  func tapModify(text: String) {
  }
  
  
  
  func tapStart(id: Int) {
    updateSupport(id: id, status: .start, gognsu: nil)
  }
  
  func tapEnd(id: Int) {
    updateSupport(id: id, status: .end, gognsu: nil)
  }
  
  func tapAttendanceReview(id: Int) {
    updateSupport(id: id, status: .review, gognsu: nil)
  }
  func tapGongsu(id: Int, Gongsu: String) {
    updateSupport(id: id, status: .end, gognsu: Double(Int(Gongsu) ?? 0))
  }
}


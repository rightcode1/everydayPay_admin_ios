//
//  ChatJoinUserVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/14.
//

import Foundation
import UIKit

class ChatJoinUserVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ChatJoinUserVC {
      let viewController = ChatJoinUserVC.viewController(storyBoardName: "Chat")
      return viewController
  }
  
  @IBOutlet weak var mainCollectionView: UICollectionView!
  @IBOutlet weak var mainTableView: UITableView!
  @IBOutlet weak var selectUserCollectionView: UICollectionView!
  @IBOutlet weak var userCollectionViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var searchNameTextField: UITextField!
  @IBOutlet weak var searchButton: UIButton!
  
  @IBOutlet weak var userJoinButton: UIButton!
  
  var roomId: Int = -1
  var tapList:[String] = ["관련유저","수동등록"]
  var selectTap = "관련유저"
  var diff = "담당자"
  var controlDiff  = false
  var userList: [ChatJoinUser] = []{
    didSet{
      mainTableView.reloadData()
    }
  }
  var otherUserList: [OtherUser] = []{
    didSet{
      mainTableView.reloadData()
    }
  }
  var selectJoinUser:[ChatJoinUser] = []
  var selectUser:[OtherUser] = []{
    didSet{
      userCollectionViewHeight.constant = CGFloat(selectUser.count * 40)
      selectUserCollectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initdelegate()
    initrx()
    
  }
  func initdelegate(){
    mainTableView.delegate = self
    mainTableView.dataSource = self
    
    
    mainCollectionView.delegate = self
    mainCollectionView.dataSource = self
    
    selectUserCollectionView.delegate = self
    selectUserCollectionView.dataSource = self
    userCollectionViewHeight.constant = 0
  }
  func initrx(){
    searchNameTextField.rx.text
        .orEmpty
        .distinctUntilChanged()
        .subscribe(onNext: { changedText in
            self.initUserList()
        })
        .disposed(by: disposeBag)
    
    searchButton.rx.tapGesture().when(.recognized)
        .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
            self.initUserList()
      })
      .disposed(by: disposeBag)
      userJoinButton.rx.tap
          .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            var users:[Int] = []
            if self.selectTap == "관련유저"{
              self.selectJoinUser = self.userList.filter{$0.isSelect ?? false}
              if self.selectJoinUser.count == 0{
                self.callOkActionMSGDialog(message: "유저를 선택해주세요.") {
                }
                return
              }
              users = self.selectJoinUser.map{$0.userId ?? 0}
            }else{
              users = self.selectUser.map{$0.id}
            }
            let param = ChatJoinRequest(userId: users, chatRoomId: self.roomId)
            APIProvider.shared.chatAPI.rx.request(.joinUser(param: param))
                    .filterSuccessfulStatusCodes()
                    .map(DefaultResponse.self)
                    .subscribe(onSuccess: { value in
                      if self.controlDiff{
                        self.backTwo()
                      }else{
                        self.backPress()
                      }
                    }, onError: { error in
                    })
                    .disposed(by: self.disposeBag)
          })
          .disposed(by: disposeBag)
  }
  
  func initUserList() {
    if selectTap == "관련유저"{
      APIProvider.shared.chatAPI.rx.request(.joinUserList(search: searchNameTextField.text!, diff: diff))
              .filterSuccessfulStatusCodes()
              .map(ChatJoinUserListResponse.self)
              .subscribe(onSuccess: { value in
                self.userList = value.list
              }, onError: { error in
              })
              .disposed(by: self.disposeBag)
    }else{
      APIProvider.shared.userAPI.rx.request(.userList(tel: searchNameTextField.text!))
              .filterSuccessfulStatusCodes()
              .map(UserListResponse.self)
              .subscribe(onSuccess: { value in
                self.otherUserList = value.list
              }, onError: { error in
              })
              .disposed(by: self.disposeBag)
    }
  }
  
}
extension ChatJoinUserVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if selectTap == "관련유저"{
      return userList.count
    }else{
      return otherUserList.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if selectTap == "관련유저"{
      let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      guard let checkImage = cell.viewWithTag(1) as? UIImageView,
            let TeamLeader = cell.viewWithTag(2) as? UILabel,
            let TeamLeaderName = cell.viewWithTag(3) as? UILabel,
            let TeamUser = cell.viewWithTag(4) as? UILabel,
            let TeamUserName = cell.viewWithTag(5) as? UILabel else { return cell }
      let dict = userList[indexPath.item]
      checkImage.image = dict.isSelect ?? false ? UIImage(named: "check_on") : UIImage(named: "check_off")
      
      TeamLeader.isHidden = dict.teamLeaderName == nil || dict.userName == nil
      TeamLeaderName.isHidden = dict.teamLeaderName == nil || dict.userName == nil
      TeamUser.isHidden = dict.teamLeaderName == nil || dict.userName == nil
      TeamUserName.isHidden = dict.userName == nil
      
      TeamLeaderName.text = dict.teamLeaderName
      TeamUserName.text = dict.userName
      return cell
    }else{
      let dict = otherUserList[indexPath.item]
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath)
        guard let name = cell.viewWithTag(1) as? UILabel,
              let tel = cell.viewWithTag(2) as? UILabel else { return cell }
      name.text = dict.name
      tel.text = dict.tel
        return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selectTap == "관련유저"{
      userList[indexPath.item].isSelect = !(userList[indexPath.item].isSelect ?? false)
    }else{
      selectUser.append(otherUserList[indexPath.row])
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}


extension ChatJoinUserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == mainCollectionView{
      return tapList.count
    }else{
      return selectUser.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == mainCollectionView{
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      guard let tapLabel = cell.viewWithTag(1) as? UILabel,
            let underLine = cell.viewWithTag(2) as? UIView else { return cell }
      let dict = tapList[indexPath.item]
    
      tapLabel.text = dict
      tapLabel.textColor = dict == selectTap ? .black : .gray
      underLine.backgroundColor = dict == selectTap ? .black : .none
      
      return cell
    }else{
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath)
      guard let name = cell.viewWithTag(2) as? UILabel,
            let phone = cell.viewWithTag(3) as? UILabel else { return cell }
      let dict = selectUser[indexPath.item]
    
      name.text = dict.name
      phone.text = dict.tel
      
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == mainCollectionView{
      selectTap = tapList[indexPath.item]
      collectionView.reloadData()
      userList.removeAll()
      selectJoinUser.removeAll()
    }else{
      selectUser = selectUser.filter{$0.id == selectUser[indexPath.row].id}
    }
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == mainCollectionView{
      return CGSize(width: (APP_WIDTH() - 40)/2, height: 30)
    }else{
      return CGSize(width: collectionView.bounds.width, height: 40)
    }
  }
}

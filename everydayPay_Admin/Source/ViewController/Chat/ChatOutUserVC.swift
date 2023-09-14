//
//  ChatJoinVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/13.
//

import Foundation
import UIKit

class ChatOutUserVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ChatOutUserVC {
      let viewController = ChatOutUserVC.viewController(storyBoardName: "Chat")
      return viewController
  }
  
  @IBOutlet weak var mainTableView: UITableView!
  
  @IBOutlet weak var outUserButton: UIButton!
  
  var roomId: Int = -1
  var selectUser: Int = -1
  var userList: [ChatUser] = []{
    didSet{
      mainTableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initdelegate()
    initUserList()
    outUser()
  }
  func initdelegate(){
    mainTableView.delegate = self
    mainTableView.dataSource = self
  }
  
  func initUserList() {
    APIProvider.shared.chatAPI.rx.request(.userList(chatRoomId: roomId))
          .filterSuccessfulStatusCodes()
          .map(ChatUserListResponse.self)
          .subscribe(onSuccess: { value in
            self.userList = value.list
            self.mainTableView.reloadData()
          }, onError: { error in
          })
          .disposed(by: disposeBag)
  }
  func outUser(){
    outUserButton.rx.tap
        .bind(onNext: { [weak self] _ in
          guard let self = self else { return }
          if self.selectUser == -1{
            self.callOkActionMSGDialog(message: "유저를 선택해주세요.") {
            }
            return
          }
          APIProvider.shared.chatAPI.rx.request(.userOut(chatRoomId: self.roomId, userId: self.selectUser, diff: "강퇴"))
                  .filterSuccessfulStatusCodes()
                  .map(DefaultResponse.self)
                  .subscribe(onSuccess: { value in
                    self.backPress()
                  }, onError: { error in
                  })
                  .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
  }
}

extension ChatOutUserVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    guard let checkImage = cell.viewWithTag(1) as? UIImageView,
          let name = cell.viewWithTag(2) as? UILabel else { return cell }
    let dict = userList[indexPath.item]
    checkImage.image = dict.isSelect ?? false ? UIImage(named: "check_on") : UIImage(named: "check_off")
    name.text = dict.userName
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    for count in 0 ..< userList.count{
      userList[count].isSelect = false
    }
    userList[indexPath.item].isSelect = !(userList[indexPath.item].isSelect ?? false)
    selectUser = userList[indexPath.item].isSelect ?? false ? userList[indexPath.row].userId ?? 0 : -1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 182
    return UITableView.automaticDimension
  }
  
}

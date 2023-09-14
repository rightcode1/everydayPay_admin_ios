//
//  ChatVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/12.
//

import Foundation
import UIKit

class ChatVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> ChatVC {
      let viewController = ChatVC.viewController(storyBoardName: "Chat")
      return viewController
  }
  @IBOutlet weak var mainCollectionView: UICollectionView!
  @IBOutlet weak var mainTableView: UITableView!
  
  
  var tapList:[String] = ["담당자","근로자"]
  var selectTap = "담당자"
  var chatList: [ChatData] = []{
    didSet{
      mainTableView.reloadData()
    }
  }
  let socketManager = SocketIOManager.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initdelegate()
    initChatList()
  }
  func initdelegate(){
    mainTableView.delegate = self
    mainTableView.dataSource = self
    
    
    mainCollectionView.delegate = self
    mainCollectionView.dataSource = self
  }
  
  func initChatList() {
    socketManager.getRoomList(diff: selectTap) { data in
      self.chatList.removeAll()
      for dict in data{
        self.chatList.append(ChatData(dict: dict))
      }
    }
  }
  
}
extension ChatVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    guard let profile = cell.viewWithTag(1) as? UIImageView,
          let name = cell.viewWithTag(2) as? UILabel,
          let content = cell.viewWithTag(3) as? UILabel,
          let time = cell.viewWithTag(4) as? UILabel else { return cell }
    let dict = chatList[indexPath.item]
    name.text = dict.title
    content.text = dict.message
    time.text = dict.updatedAt
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = ChatRoomVC.viewController()
    vc.chatRoomId = chatList[indexPath.row].id!
    vc.diff = selectTap 
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 182
    return UITableView.automaticDimension
  }
  
}


extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tapList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      guard let tapLabel = cell.viewWithTag(1) as? UILabel,
            let underLine = cell.viewWithTag(2) as? UIView else { return cell }
      
      let dict = tapList[indexPath.item]
    
      tapLabel.text = dict
      tapLabel.textColor = dict == selectTap ? .black : .gray
      underLine.backgroundColor = dict == selectTap ? .black : .none
      
      return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectTap = tapList[indexPath.item]
    collectionView.reloadData()
    initChatList()
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (APP_WIDTH() - 40)/2, height: 30)
  }
}

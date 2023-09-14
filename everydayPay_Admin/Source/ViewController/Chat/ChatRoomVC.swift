//
//  ChatRoomVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/12.
//

import Foundation
import SocketIO
import UIKit
import Photos
import DKImagePickerController

class ChatRoomVC:BaseViewController,ViewControllerFromStoryboard{
  
  
  static func viewController() -> ChatRoomVC {
    let viewController = ChatRoomVC.viewController(storyBoardName: "Chat")
    return viewController
  }
  @IBOutlet weak var mainTableView: UITableView!
  
  @IBOutlet weak var inputTextView: UITextField!
  @IBOutlet weak var sendMessageButton: UIImageView!
  @IBOutlet weak var addFileButton: UIImageView!
  @IBOutlet weak var moreButton: UIBarButtonItem!
  
  var isMine: Bool = true
  var chatRoomId: Int = -1
  var diff = "담당자"
  let socketManager = SocketIOManager.sharedInstance
  
  var messageList: [ChatMessage] = []{
    didSet{
      //      print(messageList)
      mainTableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initdelegate()
    initrx()
    socketOn()
  }
  func initdelegate(){
    mainTableView.delegate = self
    mainTableView.dataSource = self
  }
  
  func socketOn() {
    socketManager.enterRoom(chatRoomId: chatRoomId,diff: diff) { ( messageList: [ChatMessage]) in
      self.messageList = messageList
    }
    
    socketManager.messageRefresh { messageData in
      self.messageList.append(messageData)
    }
  }
  func initrx(){
    addFileButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.showImagePicker(from: self,maxSelectableCount: 1) { selectedImage in
//            if let image = selectedImage {
////              self.addFileButton.image = image
//            }
        }
      })
      .disposed(by: disposeBag)
    sendMessageButton.rx.tapGesture().when(.recognized)
        .bind(onNext: { [weak self] _ in
          guard let self = self else { return }
          if self.inputTextView.text != nil{
            self.socketManager.sendMessage(message: self.inputTextView.text!)
            self.finishSendMessageEvent()
          }
        })
        .disposed(by: disposeBag)
    moreButton.rx.tap
        .bind(onNext: { [weak self] _ in
          guard let self = self else { return }
            let vc = MoreButtonPopupView.viewController()
            vc.isMine.onNext(self.isMine)
            vc.delegate = self
            self.present(vc, animated: true)
        })
        .disposed(by: disposeBag)
  }
//  func uploadMessageFile(image: UIImage) {
//    APIProvider.shared.chatAPI.rx.request(.chatMessageFileRegister(chatRoomId: chatRoomId, image: image))
//      .filterSuccessfulStatusCodes()
//      .map(RegistChatMessageImageResponse.self)
//      .subscribe(onSuccess: { response in
//        self.socketManager.sendImage(chatRoomId: self.chatRoomId, messageId: response.data.id)
//          self.messageList.append(MessageData.init(dict: response.data.dictionary ?? [:]))
//      }, onError: { error in
//      })
//      .disposed(by: disposeBag)
//  }
  
    func finishSendMessageEvent() {
      inputTextView.text = nil
      mainTableView.scrollToBottom()
      self.view.endEditing(true)
    }
  
}
extension ChatRoomVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messageList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dict = messageList[indexPath.item]
    if dict.type == "system"{
      let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "enterUser", for: indexPath)
      guard let systemMessage = cell.viewWithTag(1) as? UILabel else { return cell }
      let dict = messageList[indexPath.item]
      systemMessage.text = dict.content
      return cell
    }else{
      if dict.userId == DataHelperTool.userId{
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "myMessageCell", for: indexPath) as! MyMessageCell
        cell.initupdate(data: dict)
        return cell
      }else{
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! MessageCell
        cell.initupdate(data: dict)
        return cell
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  
}
extension ChatRoomVC: MenuDelegate{
  func outRoom() {
  }
  
  func joinUserRoom() {
    let vc = ChatJoinUserVC.viewController()
    vc.diff = diff
    vc.roomId = chatRoomId
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func outUserRoom() {
        let vc = ChatOutUserVC.viewController()
        vc.roomId = chatRoomId
        self.navigationController?.pushViewController(vc, animated: true)
  }
}


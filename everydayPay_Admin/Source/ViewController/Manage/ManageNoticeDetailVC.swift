//
//  ManageNoticeDetailVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/16.
//

import Foundation
import UIKit
import AVFoundation
import FSCalendar


class ManageNoticeDetailVC:BaseViewController,ViewControllerFromStoryboard{
  
  
  static func viewController() -> ManageNoticeDetailVC {
    let viewController = ManageNoticeDetailVC.viewController(storyBoardName: "Manage")
    return viewController
  }
  @IBOutlet weak var mainTableView: UITableView!
  
  @IBOutlet weak var imageCollectionView: UICollectionView!
  @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
  @IBOutlet weak var pageCountLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var createLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var deepCommentView: NSLayoutConstraint!
  
  @IBOutlet weak var commentCountLabel: UILabel!
  @IBOutlet weak var deepCommentLabel: UILabel!
  
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var sendMsgButton: UIButton!
  
  var boardCommentId: Int?{
    didSet{
      if boardCommentId != nil{
        deepCommentView.constant = 30
      }else{
        deepCommentView.constant = 0
      }
    }
  }
  var id: Int = -1
  var imageList:[Image] = []{
    didSet{
      if imageList.isEmpty{
        mainTableView.layoutTableHeaderView()
        imageCollectionViewHeight.constant = 0
      }else{
        mainTableView.layoutTableHeaderView()
        imageCollectionViewHeight.constant = imageCollectionView.bounds.width
      }
      imageCollectionView.reloadData()
    }
  }
  var commentList: [CommentList] = []{
    didSet{
      mainTableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    initrx()
    initdelegate()
    initDetail()
    initCommentList()
  }
  func initdelegate(){
    mainTableView.delegate = self
    mainTableView.dataSource = self
    imageCollectionView.dataSource = self
    imageCollectionView.delegate = self
  }
  func initDetail() {
    APIProvider.shared.manageAPI.rx.request(.noticeDetail(id: id))
      .filterSuccessfulStatusCodes()
      .map(ManageBoardDetailResponse.self)
      .subscribe(onSuccess: { value in
        self.imageList = value.data.images ?? []
        self.titleLabel.text = value.data.title
        self.nameLabel.text = value.data.userName
        self.createLabel.text = value.data.createdAt
        self.contentLabel.text = value.data.content
        self.mainTableView.layoutTableHeaderView()
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  func initCommentList() {
    APIProvider.shared.manageAPI.rx.request(.commentList(boardId: id))
      .filterSuccessfulStatusCodes()
      .map(CommentListResponse.self)
      .subscribe(onSuccess: { value in
        self.commentList = value.list
        
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  func registCommentList() {
    if messageTextField.text == ""{
      showToast(message: "내용을 입력해주세요.")
      return
    }
    let param = CommentRequest(boardId: id, content: messageTextField.text!, boardCommentId: boardCommentId)
    APIProvider.shared.manageAPI.rx.request(.commentRegist(param: param))
      .filterSuccessfulStatusCodes()
      .map(DefaultResponse.self)
      .subscribe(onSuccess: { value in
        self.initCommentList()
        
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  
  func initrx(){
    sendMsgButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.registCommentList()
      })
      .disposed(by: disposeBag)
  }
  
}
extension ManageNoticeDetailVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let dict = commentList[indexPath.row]
    let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
    cell.delegate = self
    cell.initCell(data: dict)
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}

extension ManageNoticeDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    if scrollView.isEqual(self.imageCollectionView) {
      let page = Int(targetContentOffset.pointee.x / self.imageCollectionView.bounds.width)
      pageCountLabel.text = "\(page + 1)/\(imageList.count)"
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath)
    guard let image = cell.viewWithTag(1) as? UIImageView else { return cell }
    image.kf.setImage(with: URL(string: imageList[indexPath.row].name))
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = collectionView.bounds.width
    return CGSize(width: size, height: size)
  }
}
extension ManageNoticeDetailVC:  chatProtocol{
  func comment(id: Int, content: String) {
    deepCommentLabel.text = "\(content)님에게 답글 남기는중"
    boardCommentId = id
  }
  
  func delete(id: Int) {
  }
  
  func fix(id: Int) {

  }

}

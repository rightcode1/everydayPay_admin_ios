//
//  ChatCell.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/16.
//

import Foundation
import UIKit
import RxSwift

protocol chatProtocol{
  func comment(id: Int, content: String)
  func delete(id: Int)
  func fix(id: Int)
}
class ChatCell:UITableViewCell{
  @IBOutlet weak var userProfile: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var commentButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var deepLeftMargin: NSLayoutConstraint!
  
  var delegate: chatProtocol?
  var disposeBag = DisposeBag()
  
  func initCell(data: CommentList){
    initrx(data: data)
    if data.depth == 0{
      commentButton.isHidden = false
      deepLeftMargin.constant = 15
    }else{
      deepLeftMargin.constant = 55
      commentButton.isHidden = true
    }
    
    deleteButton.isHidden = !(data.userId == DataHelperTool.userId)
    userProfile.kf.setImage(with: URL(string: data.user.thumbnail ?? ""))
    nameLabel.text = data.user.name
    contentLabel.text = data.content
    dateLabel.text = data.createdAt
  }
  func initrx(data: CommentList){
    commentButton.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.delegate?.comment(id: data.id,content: data.user.name
        )
      })
      .disposed(by: disposeBag)
    deleteButton.rx.tap
      .bind(onNext: { [weak self] in
        guard let self = self else { return }
        self.delegate?.delete(id: data.id)
      })
      .disposed(by: disposeBag)
  }
}

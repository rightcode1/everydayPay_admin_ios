//
//  MessageCell.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/02/13.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell{
  @IBOutlet weak var profile: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var content: UILabel!
  @IBOutlet weak var time: UILabel!
  
  func initupdate(data: ChatMessage){
    name.text = data.userName
    content.text = data.content
    time.text = data.createdAt
  }
  
}

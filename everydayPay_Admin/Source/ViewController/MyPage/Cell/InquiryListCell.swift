//
//  InquiryListCell.swift
//  camver
//
//  Created by hoon Kim on 2022/03/02.
//

import UIKit

class InquiryListCell: UITableViewCell {
  @IBOutlet var statusLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  
  @IBOutlet var arrowImageView: UIImageView!
  
  @IBOutlet var imageBackView: UIView!
  @IBOutlet var collectionView: UICollectionView!{
    didSet {
      collectionView.delegate = self
      collectionView.dataSource = self
      
    }
  }
  
  @IBOutlet var inquiryContentView: UIView!
  @IBOutlet var contentLabel: UILabel!
  
  @IBOutlet var replyView: UIView!
  @IBOutlet var replyTitleLabel: UILabel!
  @IBOutlet var replyLabel: UILabel!
  
  var imageList: [Image] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func update(_ data: InquiryData) {
    inquiryContentView.isHidden = (data.isOpened ?? false) ? false : true
    replyView.isHidden = (data.isOpened ?? false) && data.comment != nil ? false : true
    arrowImageView.isHidden = (data.isOpened ?? false) ? true : false
    
    statusLabel.text = data.comment == nil ? "답변대기" : "답변완료"
    let statusOnColor = UIColor(red: 60/255, green: 123/255, blue: 229/255, alpha: 1.0)
    let statusOffColor = UIColor(red: 255/255, green: 51/255, blue: 51/255, alpha: 1.0)
    statusLabel.textColor = data.comment == nil ? statusOffColor : statusOnColor
    
    titleLabel.text = data.title
    dateLabel.text = data.createdAt
    
//    imageList = data.images
    collectionView.reloadData()
    
    contentLabel.text = data.content
    
    replyLabel.text = data.comment
    
    collectionView.reloadData()
  }
    
}
extension InquiryListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    guard let imageView = cell.viewWithTag(1) as? UIImageView else {
      return cell
    }
    let dict = imageList[indexPath.row]
    imageView.kf.setImage(with: URL(string: dict.name)!)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    showImageList(imageList: thumbnailsUIImageList, index: indexPath.row)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = self.collectionView.bounds.size
    return CGSize(width: size.width - 30, height: size.height)
  }
  
}

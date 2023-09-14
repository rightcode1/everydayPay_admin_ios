//
//  GuideVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/24.
//

import Foundation
import UIKit

class GuideVC:BaseViewController,ViewControllerFromStoryboard{
  
  static func viewController() -> GuideVC {
    let viewController = GuideVC.viewController(storyBoardName: "MyPage")
    return viewController
  }
  
  @IBOutlet weak var mainCollectionView: UICollectionView!
  @IBOutlet weak var collectionPageControl: UIPageControl!
  
  var imageList = [UIImage(named: "guide-1"),UIImage(named: "guide-2"),UIImage(named: "guide-3")]
  
  override func viewWillAppear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = true
    setCollectionView()
  }
  
  func setCollectionView() {
    mainCollectionView.delegate = self
    mainCollectionView.dataSource = self
  }
}
extension GuideVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    let visibleRect = CGRect(origin: mainCollectionView.contentOffset, size: mainCollectionView.bounds.size)
    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    let visibleIndexPath = mainCollectionView.indexPathForItem(at: visiblePoint)
    
    collectionPageControl.currentPage = visibleIndexPath?.row ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    guard let imageView = cell.viewWithTag(1) as? UIImageView else { return cell }
    
    imageView.image = imageList[indexPath.row]
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
  }
}


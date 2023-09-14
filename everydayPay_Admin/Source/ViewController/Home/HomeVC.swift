//
//  MainVC.swift
//  everydaypay
//
//  Created by haon on 2022/10/06.
//

import UIKit

class HomeVC: BaseViewController, ViewControllerFromStoryboard {
  @IBOutlet weak var bannerCollectionView: UICollectionView!
  @IBOutlet weak var bannerPageControl: UIPageControl!
  
  @IBOutlet weak var homeCategoryCollectionView: UICollectionView!
  @IBOutlet weak var subCategoryCollectionView: UICollectionView!
  @IBOutlet weak var subCategoryCollectionViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var titleHeaderView: UIView!
  
  @IBOutlet weak var chatButton: UIButton!
  
  var homeCategoryList: [HomeCategory] = [.건설, .공장, .농장, .파출]
  var homeCategory: HomeCategory = .건설
  
  var subCategoryList: [(String, UIImage)] = []
  
  var timer: Timer?
  var advertisementList: [AdvertisementData] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initrx()
    setTitleHeaderView()
    setCollectionView()
    initSubCateogryList()
    initAdvertise()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = false
    invalidateTimer()
  }
  
  static func viewController() -> HomeVC {
    let viewController = HomeVC.viewController(storyBoardName: "Home")
    return viewController
  }
  
  func setTitleHeaderView(){
    titleHeaderView?.layer.cornerRadius  = 20
    titleHeaderView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
  }
  
  func setCollectionView() {
    bannerCollectionView.delegate = self
    bannerCollectionView.dataSource = self
    
    homeCategoryCollectionView.delegate = self
    homeCategoryCollectionView.dataSource = self
    
    subCategoryCollectionView.delegate = self
    subCategoryCollectionView.dataSource = self
    
    homeCategoryCollectionView.reloadData()
  }
  
  func initSubCateogryList() {
    subCategoryList = homeCategory.getList()
    subCategoryCollectionView.reloadData()
    subCategoryCollectionView.layoutSubviews()
    
    subCategoryCollectionViewHeight.constant = subCategoryCollectionView.contentSize.height
  }
  
  private func visibleCellIndexPath() -> IndexPath {
    return bannerCollectionView.indexPathsForVisibleItems[0]
  }
  
  private func invalidateTimer() {
    timer?.invalidate()
  }
  
  private func activateTimer() {
    if timer != nil {
      timer?.invalidate()
    }
    
    timer = Timer.scheduledTimer(timeInterval: 3,
                                 target: self,
                                 selector: #selector(timerCallBack),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  @objc func timerCallBack() {
    var item = visibleCellIndexPath().item
    if item == advertisementList.count * 3 - 1 {
      bannerCollectionView.scrollToItem(at: IndexPath(item: advertisementList.count * 2 - 1, section: 0),
                                        at: .centeredHorizontally,
                                        animated: false)
      item = advertisementList.count * 2 - 1
    }
    
    item += 1
    bannerCollectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                      at: .centeredHorizontally,
                                      animated: true)
    let unitCount: Int = item % advertisementList.count
    bannerPageControl.currentPage = unitCount
  }
  
  func initAdvertise() {
    let param = AdvertisementListRequest(userDiff: .업체, location: .메인배너)
      APIProvider.shared.advertiseAPI.rx.request(.advertisementList(param: param))
          .filterSuccessfulStatusCodes()
          .map(AdListResponse.self)
          .subscribe(onSuccess: { value in
            self.advertisementList = value.list
            self.bannerCollectionView.reloadData()
            self.activateTimer()
          }, onError: { error in
          })
          .disposed(by: disposeBag)
  }
  func initrx(){
    chatButton.rx.tapGesture().when(.recognized)
      .bind(onNext: { [weak self] _ in
        guard let self = self else { return }
        let vc = ChatVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
      })
      .disposed(by: disposeBag)
  }
  
  
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView.isEqual(self.bannerCollectionView) {
      invalidateTimer()
      activateTimer()
      
      var item = visibleCellIndexPath().item
      if item == advertisementList.count * 3 - 2 {
        item = advertisementList.count * 2
      } else if item == 1 {
        item = advertisementList.count + 1
      }
      bannerCollectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                        at: .centeredHorizontally,
                                        animated: false)
      
      let unitCount: Int = item % advertisementList.count
      bannerPageControl.currentPage = unitCount
    }
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //    if scrollView.isEqual(self.advertisementCollectionView) {
    //      let page = Int(targetContentOffset.pointee.x / self.advertisementCollectionView.bounds.width)
    //      print(page)
    //      advertisementCountLabel.text = "\(page + 1)/\(advertisementList.count)"
    //    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == bannerCollectionView {
      return advertisementList.count * 3
    } else if (collectionView == homeCategoryCollectionView) {
      return homeCategoryList.count
    } else {
      return subCategoryList.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if bannerCollectionView == collectionView {
      let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      guard let imageView = cell.viewWithTag(1) as? UIImageView else { return cell }
      
      let dict = advertisementList[indexPath.item % advertisementList.count]
      
      imageView.kf.setImage(with: URL(string: dict.thumbnail ))
      
      return cell
    } else if (collectionView == homeCategoryCollectionView) {
      let cell = homeCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      guard let titleLabel = cell.viewWithTag(1) as? UILabel,
            let selectedView = cell.viewWithTag(2) else { return cell }
      
      let dict = homeCategoryList[indexPath.row]
      
      
      titleLabel.textColor = dict == homeCategory ? .black : UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1.0)
      titleLabel.text = dict.rawValue
      selectedView.isHidden = dict != homeCategory
      
      
      return cell
    } else {
      let cell = subCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      guard let imageView = cell.viewWithTag(1) as? UIImageView else { return cell }
      
      let dict = subCategoryList[indexPath.row]
      
      imageView.image = dict.1
      
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == bannerCollectionView {
      
    } else if (collectionView == homeCategoryCollectionView) {
      let dict = homeCategoryList[indexPath.row]
      homeCategory = dict
      homeCategoryCollectionView.reloadData()
      initSubCateogryList()
    }  else {
      let vc = HomeCategoryListVC.viewController()
      vc.homeCategory = homeCategory
      vc.homeSecondCategory = homeCategory.getList()[indexPath.row].0
      self.navigationController?.pushViewController(vc, animated: true)
      
    }
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == bannerCollectionView {
      let size = bannerCollectionView.bounds.size
      return CGSize(width: size.width, height: size.height)
    } else if collectionView == homeCategoryCollectionView {
      return CGSize(width: 29, height: 28)
    } else {
      let size = (APP_WIDTH() - 100) / 4
      return CGSize(width: size, height: size)
    }
  }
}

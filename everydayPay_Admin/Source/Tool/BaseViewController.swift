//
//  BaseViewController.swift
//  cheorwonHotPlace
//
//  Created by hoon Kim on 28/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Alamofire
import Moya
import Kingfisher
import UserNotifications
import DKImagePickerController

class BaseViewController: UIViewController, UIGestureRecognizerDelegate{

  // MARK: Rx
  
  var disposeBag = DisposeBag()
  
  @IBInspectable var localizedText: String = "" {
    didSet {
      if localizedText.count > 0 {
        #if TARGET_INTERFACE_BUILDER
        var bundle = NSBundle(forClass: type(of: self))
        self.title = bundle.localizedStringForKey(self.localizedText, value:"", table: nil)
        #else
        self.title = NSLocalizedString(self.localizedText, comment:"");
        #endif
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.clipsToBounds = true
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    
    // EnterForeground -> applicationWillEnterForeground -> applcation(_: open url: options:) -> applicationDidBecomeActive 순서로 진행 됨
    notificationCenter.addObserver(self, selector: #selector(backgroundMovedToApp), name: UIApplication.didBecomeActiveNotification, object: nil)
  }
  
  @objc func appMovedToBackground() {
    print("App moved to background!")
  }

  @objc func backgroundMovedToApp() {
    print("Background moved to app!")
//    shareEvents()
  }
  
  func shareEvents() {
//    if shareFeedId != 0 {
//      let vc = UIStoryboard.init(name: "Sns", bundle: nil).instantiateViewController(withIdentifier: "feedList") as! FeedListViewController
//      vc.shareId = shareFeedId
//      navigationController?.pushViewController(vc, animated: true)
//      shareFeedId = 0
//    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func registNorificationToken() {
    let param = RegistNotificationTokenRequest(notificationToken: FcmToken)
    APIProvider.shared.defaultAPI.rx.request(.registNotificationToken(param: param))
      .filterSuccessfulStatusCodes()
      .subscribe(onSuccess: { response in
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  
  func userInfo(result: @escaping (UserInfoResponse) -> Void) {
    APIProvider.shared.userAPI.rx.request(.userInfo)
      .filterSuccessfulStatusCodes()
      .map(UserInfoResponse.self)
      .subscribe(onSuccess: { response in
        DataHelper.set(response.data.id, forKey: .userAppId)
        result(response)
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  
  func userLogout(result: @escaping (DefaultResponse) -> Void) {
    APIProvider.shared.userAPI.rx.request(.userLogout)
      .filterSuccessfulStatusCodes()
      .map(DefaultResponse.self)
      .subscribe(onSuccess: { response in
        result(response)
      }, onError: { error in
      })
      .disposed(by: disposeBag)
  }
  
  
  func chageStringtoDate(date:String)-> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let convertDate = dateFormatter.date(from: date)
    return convertDate ?? Date()
  }
  func changeDatetoString(date: Date) -> String{
    let monthDateFormatter = DateFormatter()
    monthDateFormatter.dateFormat = "yyyy-MM-dd"
    return monthDateFormatter.string(from: date)
  }
  
  func changeDatetoMonthString(date: Date) -> String{
    let monthDateFormatter = DateFormatter()
    monthDateFormatter.dateFormat = "yyyy-MM"
    return monthDateFormatter.string(from: date)
  }
  
  
    func goMain() {
      let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
      vc.modalPresentationStyle = .fullScreen
      self.present(vc, animated: true, completion: nil)
    }
  func showImagePicker(from viewController: UIViewController, maxSelectableCount: Int = 1, completion: @escaping ([UIImage]) -> Void) {
      let pickerController = DKImagePickerController()
      pickerController.maxSelectableCount = maxSelectableCount
      pickerController.didSelectAssets = { (assets: [DKAsset]) in
          var selectedImages = [UIImage]()
          let dispatchGroup = DispatchGroup()
          for asset in assets {
              dispatchGroup.enter()
              asset.fetchOriginalImage(completeBlock: { (image, info) in
                  if let selectedImage = image {
                      selectedImages.append(selectedImage)
                  }
                  dispatchGroup.leave()
              })
          }
          dispatchGroup.notify(queue: .main) {
              completion(selectedImages)
          }
      }
      pickerController.didCancel = {
          completion([])
      }
      viewController.present(pickerController, animated: true, completion: nil)
  }


}

extension BaseViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


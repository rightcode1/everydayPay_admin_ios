//
//  ViewcontrollerExtention.swift
//  FOAV
//
//  Created by hoon Kim on 02/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//
import Foundation
import UIKit
import JGProgressHUD
import PopupDialog

extension UIViewController {
  var progressHUD: JGProgressHUD {
    let hud = JGProgressHUD(style: .dark)
    return hud
  }
  
  func showHUD(){
    self.progressHUD.show(in: self.view, animated: true)
    self.view.isUserInteractionEnabled = false
  }
  
  func dismissHUD(){
    JGProgressHUD.allProgressHUDs(in: self.view).forEach{ hud in
      hud.dismiss(animated: true)
    }
    self.view.isUserInteractionEnabled = true
  }
  
  func callMSGDialog(title: String? = "",message: String, buttonTitle: String? = nil) {
    let custom = PopupDialog(
      title: title,
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: true,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    let button = DefaultButton(title: buttonTitle ?? "확인") {
      
    }
    button.titleColor = .white
    button.buttonColor = #colorLiteral(red: 0.9511048198, green: 0.4408145249, blue: 0.1368482113, alpha: 1)
    custom.addButton(button)
    self.present(custom, animated: true, completion: nil)
  }

  
  func callOkActionMSGDialog(title: String? = "", message: String, okAction: @escaping () -> Void) {
    let custom = PopupDialog(
      title: title,
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: false,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    let button = DefaultButton(title: "확인") {
      okAction()
    }
    button.titleColor = .white
    button.buttonColor = #colorLiteral(red: 0.9511640668, green: 0.4395188689, blue: 0.1397989094, alpha: 1)
    custom.addButton(button)
    self.present(custom, animated: true, completion: nil)
  }
  
  func callYesNoMSGDialog(title: String? = "",yesButtonTitle: String? = nil, noButtonTitle: String? = nil, message: String, okAction: @escaping () -> Void) {
    let custom = PopupDialog(
      title: title,
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: false,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    
    let noButton = DefaultButton(title: (noButtonTitle == nil ? "취소" : noButtonTitle)!) {
      
    }
    let yesButton = DefaultButton(title: (yesButtonTitle == nil ? "확인" : yesButtonTitle)!) {
      okAction()
    }
    
    noButton.titleColor = .black
    noButton.buttonColor = .white
    custom.addButton(noButton)
    
    
    yesButton.titleColor = .white
    yesButton.buttonColor = UIColor(red: 129/255, green: 216/255, blue: 208/255, alpha: 1.0)
    custom.addButton(yesButton)
    
    self.present(custom, animated: true, completion: nil)
  }
  
  func callYesNoActionMSGDialog(title: String? = "",yesButtonTitle: String? = nil, noButtonTitle: String? = nil, message: String, okAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
    let custom = PopupDialog(
      title: title,
      message: message,
      image: nil,
      buttonAlignment: NSLayoutConstraint.Axis.horizontal,
      transitionStyle: PopupDialogTransitionStyle.zoomIn,
      preferredWidth: self.view.frame.size.width - 100,
      tapGestureDismissal: false,
      panGestureDismissal: false,
      hideStatusBar: false,
      completion: nil
    )
    
    let dialogAppearance = PopupDialogDefaultView.appearance()
    dialogAppearance.messageColor = .black
    
    let noButton = DefaultButton(title: (noButtonTitle == nil ? "취소" : noButtonTitle)!) {
      cancelAction()
    }
    let yesButton = DefaultButton(title: (yesButtonTitle == nil ? "확인" : yesButtonTitle)!) {
      okAction()
    }
    
    noButton.titleColor = .black
    noButton.buttonColor = .white
    custom.addButton(noButton)
    
    
    yesButton.titleColor = .white
    yesButton.buttonColor = UIColor(red: 129/255, green: 216/255, blue: 208/255, alpha: 1.0)
    custom.addButton(yesButton)
    
    self.present(custom, animated: true, completion: nil)
  }
  
  // "네" "아니오" 선택할 수 있는 얼럿 함수
  func choiceAlert(message: String, okAction: @escaping () -> Void) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let noAction = UIAlertAction(title: "아니요", style: UIAlertAction.Style.cancel)
    let yesAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default) { (action) in
      okAction()
    }
    alert.addAction(noAction)
    alert.addAction(yesAction)
    self.present(alert, animated: true, completion: nil)
  }
  // 확인버튼 누르면 액션 이벤트하는 얼럿
  func okActionAlert(message: String, okAction: @escaping () -> Void) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let yesAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) {
      (action) in
      okAction()
    }
    alert.addAction(yesAction)
    self.present(alert, animated: true, completion: nil)
  }
  // 확인 버튼만 있는 얼럿 함수
  func doAlert(message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let yesAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
    alert.addAction(yesAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  // String의 width 구하는 함수
  func textWidth(text: String, font: UIFont?) -> CGFloat {
    let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
    return text.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
  }
  
  func showToast(message : String, font: UIFont? = UIFont.systemFont(ofSize: 14), yPosition: CGFloat? = nil) {
    let textWidth = textWidth(text: message, font: font) + 24
    let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width/2) - (textWidth/2), y: yPosition ?? 250, width: textWidth, height: 38))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.85)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 12;
    toastLabel.clipsToBounds = true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 1.75, delay: 0.1, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    },
    completion: { (isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }
  
  // 네비게이션 바 타이틀 UI 넣어주는 함수
  func navigationTitleUI(_ image: UIImage) {
    let logoView = UIView(frame: CGRect(x: 0, y: 0, width: 100 , height: 40))
    
    let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 100 , height: 40))
    logo.contentMode = .scaleAspectFit
    
    logo.image = image
    logoView.addSubview(logo)
    self.navigationItem.titleView = logoView
  }
  
  func moveToLoginNC() {
    let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNC")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
  func moveToLoginVC() {
//    let vc = LoginVC.viewController()
//    vc.isBack = true
//    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func moveToMain() {
    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func backTwo() {
    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
  }
  
  @IBAction func backThree() {
    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
    self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
  }
  
  @IBAction func backPress() {
    if let navigationController = navigationController{
      if let rootViewController = navigationController.viewControllers.first, rootViewController.isEqual(self){
        dismiss(animated: true, completion: nil)
      } else {
        navigationController.popViewController(animated: true)
      }
    }else{
      dismiss(animated: true, completion: nil)
    }
  }

  
  @IBAction func rootBackPress() {
    if let navigationController = navigationController {
      if let rootViewController = navigationController.viewControllers.first, rootViewController.isEqual(self) {
        dismiss(animated: true, completion: nil)
      } else {
        self.navigationController?.popToRootViewController(animated: true)
      }
    } else {
      dismiss(animated: true, completion: nil)
    }
  }
  
    var wrapNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}


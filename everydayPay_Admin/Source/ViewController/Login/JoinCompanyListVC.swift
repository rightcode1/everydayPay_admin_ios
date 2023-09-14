//
//  JoinCompanyListVC.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/17.
//

import Foundation
import UIKit

class JoinCompanyListVC:BaseViewController,ViewControllerFromStoryboard{
    static func viewController() -> JoinCompanyListVC {
      let viewController = JoinCompanyListVC.viewController(storyBoardName: "Login")
      return viewController
    }
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var newCompanyButton: UIButton!
    
    var companyList:[CompanyData] = []
    var selectCompany: Int = -1
    var selectCompanyName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        initrx()
        CompanyList()
    }
    func CompanyList() {
        let param = CompnayListRequest(search: searchTextField.text ?? "")
      APIProvider.shared.companyAPI.rx.request(.companyList(param: param))
        .filterSuccessfulStatusCodes()
        .map(CompanyListResponse.self)
        .subscribe(onSuccess: { value in
            self.companyList = value.list
            self.mainTableView.reloadData()
        }, onError: { error in
        })
        .disposed(by: disposeBag)
    }
    
    func initrx(){
        searchTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.CompanyList()
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                self.CompanyList()
          })
          .disposed(by: disposeBag)
        
        joinButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                if self.selectCompany == -1{
                    self.callOkActionMSGDialog(message: "업체를 선택해주세요.") {
                    }
                    return
                }
                let vc = JoinVC.viewController()
                vc.selectCompnayName = self.selectCompanyName
                vc.selectCompanyId = self.selectCompany
                self.navigationController?.pushViewController(vc, animated: true)
          })
          .disposed(by: disposeBag)
        
        newCompanyButton.rx.tapGesture().when(.recognized)
            .bind(onNext: { [weak self] _ in
            guard let self = self else { return }
                let vc = JoinVC.viewController()
                vc.isNewCompany = true
                self.navigationController?.pushViewController(vc, animated: true)
          })
          .disposed(by: disposeBag)
    }
}
extension JoinCompanyListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dict = companyList[indexPath.row]
        guard let checkImage = cell.viewWithTag(1) as? UIImageView,
              let companyName = cell.viewWithTag(2) as? UILabel else {
                return cell
              }
        checkImage.image = selectCompany == dict.id ? UIImage(named: "check_on") : UIImage(named: "check_off")
        companyName.text = dict.name
        
        return cell
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let dict = companyList[indexPath.row]
          selectCompany = dict.id
          selectCompanyName = dict.name
          mainTableView.reloadData()
          
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
}

//
//  HomeCategoryModel.swift
//  everydaypay
//
//  Created by haon on 2022/10/06.
//

import Foundation
import UIKit

enum HomeCategory: String, Codable {
  case 건설
  case 공장
  case 농장
  case 파출
  
  func getList() -> [(String, UIImage)] {
    switch self {
    case .건설:
      return [("일반인부", UIImage(named: "constructionIcon1")!), ("조공", UIImage(named: "constructionIcon2")!), ("신호수", UIImage(named: "constructionIcon3")!),
              ("자재정리", UIImage(named: "constructionIcon4")!), ("철근", UIImage(named: "constructionIcon5")!), ("형틀목수", UIImage(named: "constructionIcon6")!),
              ("비계", UIImage(named: "constructionIcon7")!), ("콘크리트", UIImage(named: "constructionIcon8")!), ("방수", UIImage(named: "constructionIcon9")!),
              ("타일", UIImage(named: "constructionIcon10")!), ("미장", UIImage(named: "constructionIcon11")!), ("운반", UIImage(named: "constructionIcon12")!),
              ("설비", UIImage(named: "constructionIcon13")!), ("전기", UIImage(named: "constructionIcon14")!), ("용접", UIImage(named: "constructionIcon15")!),
              ("철거해제", UIImage(named: "constructionIcon16")!), ("할석", UIImage(named: "constructionIcon17")!), ("조적", UIImage(named: "constructionIcon18")!),
              ("경계석", UIImage(named: "constructionIcon19")!), ("석공", UIImage(named: "constructionIcon20")!), ("도배", UIImage(named: "constructionIcon21")!),
              ("페인트", UIImage(named: "constructionIcon22")!), ("조경", UIImage(named: "constructionIcon23")!), ("준공청소", UIImage(named: "constructionIcon24")!)]
    case .공장:
      return [("생산직", UIImage(named: "factoryIcon1")!), ("사무직", UIImage(named: "factoryIcon2")!), ("경비", UIImage(named: "factoryIcon3")!)]
    case .농장:
      return [("과수원", UIImage(named: "farmIcon2")!), ("텃밭", UIImage(named: "farmIcon2")!)]
    case .파출:
      return [("주방장", UIImage(named: "dispatchIcon1")!), ("주방보조", UIImage(named: "dispatchIcon2")!), ("홀서빙", UIImage(named: "dispatchIcon3")!),
              ("매니저", UIImage(named: "dispatchIcon4")!)]
    }
  }
}


//
//  Enum+Category.swift
//  LifeStyleForBeauty
//
//  Created by haon on 2022/07/11.
//

import UIKit

enum BeautyCategory: String, Codable {
  case 전체
  case 페이스윤곽
  case 페이스피부
  case 바디
  case 특별
  case 그외
  
  var subCategoryList: [String] {
    switch self {
    case .전체:
      return []
    case .페이스윤곽:
      return ["전체",
              "축소/리프팅관리",
              "광대관리",
              "V라인관리",
              "하관관리"]
    case .페이스피부:
      return ["전체",
              "피부트러블관리",
              "미백관리",
              "광채관리",
              "안티에이징관리",
              "탄력관리",
              "모공관리",
              "재생관리",
              "보습관리",
              "각질관리",
              "주름관리",
              "수분관리",
              "건성관리",
              "지성관리",
              "기미관리"]
    case .바디:
      return ["전체",
              "목관리",
              "상체관리",
              "복부관리",
              "등관리",
              "엉덩이관리",
              "하체관리"]
    case .특별:
      return ["전체",
              "웨딩관리",
              "산전관리",
              "산후관리",
              "커플관리",]
    case .그외:
      return ["기기관리"]
    }
  }
  
  var onImage: UIImage {
    switch self {
    case .전체:
      return UIImage(named: "categoryOn")!
    case .페이스윤곽:
      return UIImage(named: "category1On")!
    case .페이스피부:
      return UIImage(named: "category2On")!
    case .바디:
      return UIImage(named: "category3On")!
    case .특별:
      return UIImage(named: "category4On")!
    case .그외:
      return UIImage(named: "category5On")!
    }
  }
  
  var offImage: UIImage {
    switch self {
    case .전체:
      return UIImage(named: "categoryOff")!
    case .페이스윤곽:
      return UIImage(named: "category1Off")!
    case .페이스피부:
      return UIImage(named: "category2Off")!
    case .바디:
      return UIImage(named: "category3Off")!
    case .특별:
      return UIImage(named: "category4Off")!
    case .그외:
      return UIImage(named: "category5Off")!
    }
  }
  
  var imageWidth: CGFloat {
    switch self {
    case .페이스윤곽:
      return 134
    case .페이스피부:
      return 131
    default:
      return 90
    }
  }
}

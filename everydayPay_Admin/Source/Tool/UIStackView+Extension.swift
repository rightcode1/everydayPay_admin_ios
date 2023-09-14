//
//  UIStackView+Extension.swift
//  WellCar
//
//  Created by hoonKim on 2021/07/30.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

extension UIStackView {
  func removeAllArrangedSubviews() {
    arrangedSubviews.forEach {
      self.removeArrangedSubview($0)
      NSLayoutConstraint.deactivate($0.constraints)
      $0.removeFromSuperview()
    }
  }
}

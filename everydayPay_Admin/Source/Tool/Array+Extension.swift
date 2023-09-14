//
//  Array+Extension.swift
//  LifeStyleForBeauty
//
//  Created by haon on 2022/08/08.
//

import Foundation

// 배열 값을 알고 잇으면 배열 값으로 해당 값을 지울수 잇는 extension
extension Array where Element: Equatable {
    
    mutating func remove(_ element: Element) {
      _ = firstIndex(of: element).flatMap {
            self.remove(at: $0)
        }
    }
}

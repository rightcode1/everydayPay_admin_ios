//
//  TableView + Extension.swift
//  cheorwonHotPlace
//
//  Created by hoon Kim on 07/02/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  
  //Variable-height UITableView tableHeaderView with autolayout
  func layoutTableHeaderView() {
    
    guard let headerView = self.tableHeaderView else { return }
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    let headerWidth = headerView.bounds.size.width;
    let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": headerWidth], views: ["headerView": headerView])
    
    headerView.addConstraints(temporaryWidthConstraints)
    
    headerView.setNeedsLayout()
    headerView.layoutIfNeeded()
    
    let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    let height = headerSize.height
    var frame = headerView.frame
    
    frame.size.height = height
    headerView.frame = frame
    
    self.tableHeaderView = headerView
    
    headerView.removeConstraints(temporaryWidthConstraints)
    headerView.translatesAutoresizingMaskIntoConstraints = true
    
  }
  
  func layoutTableFooterView() {
    guard let footerView = self.tableFooterView else { return }
    footerView.translatesAutoresizingMaskIntoConstraints = false
    
    let footerWidth = footerView.bounds.size.width;
    let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[footerView(width)]", options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)), metrics: ["width": footerWidth], views: ["footerView": footerView])
    
    footerView.addConstraints(temporaryWidthConstraints)
    
    footerView.setNeedsLayout()
    footerView.layoutIfNeeded()
    
    let footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    let height = footerSize.height
    var frame = footerView.frame
    
    frame.size.height = height
    footerView.frame = frame
    
    self.tableFooterView = footerView
    
    footerView.removeConstraints(temporaryWidthConstraints)
    footerView.translatesAutoresizingMaskIntoConstraints = true
  }
  
  
  func scrollToBottom(animated: Bool = true) {
    let sections = self.numberOfSections
    let rows = self.numberOfRows(inSection: sections - 1)
    if (rows > 0){
      self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
    }
  }
  
  func scrollToTop(animated: Bool = true) {
    let sections = self.numberOfSections
    let rows = self.numberOfRows(inSection: sections - 1)
    if (rows > 0) {
      self.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: .bottom, animated: animated)
    }
  }
  
}


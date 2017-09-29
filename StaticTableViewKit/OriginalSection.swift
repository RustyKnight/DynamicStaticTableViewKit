//
//  OriginalSection.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import UIKit

class OriginalSection {

  let rows: [OriginalRow]
  
  init(rows: [OriginalRow]) {
    self.rows = rows
  }
  
  var numberOfVisibleRows: Int {
    let filtered = rows.filter { !$0.isHidden }
    return filtered.count
  }
  
  func visibleRowIndex(for cell: UITableViewCell) -> Int? {
    return rows.index(where: { $0.cell == cell })
  }
}

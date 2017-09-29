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
	
	var visibleRows: [OriginalRow] {
		return rows.filter { !$0.isHidden }
	}
  
  func visibleRowIndex(for cell: UITableViewCell) -> Int? {
    return rows.index(where: { $0.cell == cell })
  }
	
	func visibleRow(at rowIndex: Int) -> OriginalRow? {
		let visibleRows = self.visibleRows
		guard rowIndex >= 0 && rowIndex < visibleRows.count else {
			return nil
		}
		return visibleRows[rowIndex]
	}
}

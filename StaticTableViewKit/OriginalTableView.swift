//
//  OriginalTable.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import UIKit

enum OriginalTableError: Error {
  case invalidDataSource
}

class OriginalTableView {
  var sections: [OriginalSection] = []
  var tableView: UITableView
  var indexPaths: [BatchOperation: [Int]] = [:]
  
  init(tableView: UITableView) throws {
    guard let dataSource = tableView.dataSource else {
      throw OriginalTableError.invalidDataSource
    }
    self.tableView = tableView
    for sectionIndex in 0..<tableView.numberOfSections {
      var rows: [OriginalRow] = []
      for rowIndex in 0..<tableView.numberOfRows(inSection: sectionIndex) {
        let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath)
        let originalRow = OriginalRow(indexPath: indexPath, cell: cell)
        rows.append(originalRow)
      }
      let originalSection = OriginalSection(rows: rows)
      sections.append(originalSection)
    }
  }
	
	func row(at indexPath: IndexPath) -> OriginalRow {
		let section = sections[indexPath.section]
		// Should this be a method call?
		return section.rows[indexPath.row]
	}
	
	func visibleRow(at indexPath: IndexPath) -> OriginalRow? {
		let section = sections[indexPath.section]
		return section.visibleRow(at: indexPath.row)
	}
	
	func rowW(with cell: UITableViewCell) -> OriginalRow? {
		for section in sections {
			for row in section.rows {
				guard row.cell == cell else {
					continue
				}
				return row
			}
		}
		return nil
	}
	
	func indexPath(forRow row: OriginalRow) -> IndexPath {
		
	}
}

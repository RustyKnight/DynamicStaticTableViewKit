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

class OriginalTable {
  var sections: [OriginalSection] = []
  var tableView: UITableView
  var indexPaths: [BatchOperation: [Int]] = [:]
  
  init?(tableView: UITableView) throws {
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
}

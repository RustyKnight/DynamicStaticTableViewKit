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

public class StaticTableViewModel {
  
  var sections: [OriginalSection] = []
  var tableView: UITableView
  var operationIndexPaths: [BatchOperation: [IndexPath]] = [:]
  
  var insertOperations: [IndexPath] {
    return operations(for: .insert)
  }
  
  var deleteOperations: [IndexPath] {
    return operations(for: .delete)
  }
  
  var updateOperations: [IndexPath] {
    return operations(for: .update)
  }

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
  
  func operations(for batch: BatchOperation) -> [IndexPath] {
    guard let operations = operationIndexPaths[batch] else {
      return []
    }
    return operations
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
	
	func row(with cell: UITableViewCell) -> OriginalRow? {
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
  
	func visibleIndexPath(for row: OriginalRow, useActualState: Bool) -> IndexPath {
    let section = sections[row.indexPath.section]
    var visibleRow = -1
    for rowIndex in 0..<row.indexPath.row {
      let row = section.rows[rowIndex]
			let state = useActualState ? row.isHidden : row.isHiddenReal
      guard !state else {
        continue
      }
      visibleRow += 1
    }
    visibleRow += 1
    return IndexPath(row: visibleRow, section: row.indexPath.section)
  }
	
  func insertingIndexPath(forRow row: OriginalRow) -> IndexPath {
    return visibleIndexPath(for: row, useActualState: true)
  }
  
  func deletingIndexPath(forRow row: OriginalRow) -> IndexPath {
    return visibleIndexPath(for: row, useActualState: false)
  }
  
  func prepareUpdates() {
    
    var insertOperations: [IndexPath] = []
    var deleteOperations: [IndexPath] = []
    var updateOperations: [IndexPath] = []
    
    for section in sections {
      for row in section.rows {
        switch row.batchOperation {
        case .delete: deleteOperations.append(deletingIndexPath(forRow: row))
        case .insert: insertOperations.append(insertingIndexPath(forRow: row))
        case .update: updateOperations.append(insertingIndexPath(forRow: row))
        case .none: break
        }
      }
    }
		
		print("insert - \(insertOperations)")
		print("delete - \(deleteOperations)")
		print("update - \(updateOperations)")

    operationIndexPaths[.delete] = deleteOperations
    operationIndexPaths[.insert] = insertOperations
    operationIndexPaths[.update] = updateOperations
    
    for section in sections {
      for row in section.rows {
        row.isHiddenReal = row.isHiddenPlanned
        row.batchOperation = .none
      }
    }
  }
}

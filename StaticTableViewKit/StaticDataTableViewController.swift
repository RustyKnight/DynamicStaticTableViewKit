//
//  StaticDataTableViewController.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import UIKit

public class StaticDataTableViewController: UITableViewController {
  
  // MARK: Custom properties
  
	public var hideEmptySections: Bool = true
	public var animateSectionHeaders: Bool = true
	
	public var insertTableViewRowAnimation: UITableViewRowAnimation = .automatic
	public var deleteTableViewRowAnimation: UITableViewRowAnimation = .automatic
	public var reloadTableViewRowAnimation: UITableViewRowAnimation = .automatic
  
  var originalTable: StaticTableController?
  
  // MARK: Custom functionality

	public func cellIsHidden(_ cell: UITableViewCell) -> Bool {
    guard let controller = originalTable else {
      return false
    }
    guard let row = controller.row(with: cell) else {
      return false
    }
    return row.isHidden
	}
	
	public func update(cell: UITableViewCell...) {
    guard let controller = originalTable else {
      return
    }
    for aCell in cell {
      guard let row = controller.row(with: aCell) else {
        continue
      }
      row.update()
    }
	}
	
	public func cell(_ cell: UITableViewCell, hide: Bool) {
    guard let controller = originalTable else {
      return
    }
    guard let row = controller.row(with: cell) else {
      return
    }
    row.isHidden = hide
	}
	
	public func cell(_ cell: UITableViewCell..., height: Float) {
    guard let controller = originalTable else {
      return
    }
    for aCell in cell {
      guard let row = controller.row(with: aCell) else {
        continue
      }
      row.height = height
    }
	}
	
	public func reloadData(animated: Bool) {
    guard let controller = originalTable else {
      return
    }
    controller.prepareUpdates()
    guard animated else {
      tableView.reloadData()
      return
    }
    if animateSectionHeaders {
      if let paths = controller.operationIndexPaths[.delete] {
        for indexPath in paths {
          let cell = tableView.cellForRow(at: indexPath)
          cell?.layer.zPosition = -2
          tableView.headerView(forSection: indexPath.section)?.layer.zPosition = -1
        }
      }
    }
    tableView.beginUpdates()
    tableView.reloadRows(at: controller.updateOperations, with: reloadTableViewRowAnimation)
    tableView.reloadRows(at: controller.insertOperations, with: insertTableViewRowAnimation)
    tableView.reloadRows(at: controller.deleteOperations, with: deleteTableViewRowAnimation)
    tableView.endUpdates()
    if animateSectionHeaders {
      tableView.reloadData()
    }
	}
  
  // MARK: Common Functionality
  
  // Must be implemented
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override init(style: UITableViewStyle) {
    super.init(style: style)
    //??
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    do {
      originalTable = try StaticTableController(tableView: tableView)
    } catch let error {
      print(error)
    }
  }
}

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
  
  var staticTableViewController: StaticTableViewController?
  
  // MARK: Custom functionality

	public func cellIsHidden(_ cell: UITableViewCell) -> Bool {
    guard let controller = staticTableViewController else {
      return false
    }
    guard let row = controller.row(with: cell) else {
      return false
    }
    return row.isHidden
	}
	
	public func update(cell: UITableViewCell...) {
    guard let controller = staticTableViewController else {
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
    guard let controller = staticTableViewController else {
      return
    }
    guard let row = controller.row(with: cell) else {
      return
    }
    row.isHidden = hide
	}
	
	public func cell(_ cell: UITableViewCell..., height: CGFloat) {
    guard let controller = staticTableViewController else {
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
    guard let controller = staticTableViewController else {
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
      staticTableViewController = try StaticTableViewController(tableView: tableView)
    } catch let error {
      print(error)
    }
  }
	
	// MARK: TableView Data Source
	
	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let controller = staticTableViewController else {
			return super.tableView(tableView, numberOfRowsInSection: section)
		}
		return controller.sections[section].numberOfVisibleRows
	}
	
	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let controller = staticTableViewController else {
			return super.tableView(tableView, cellForRowAt: indexPath)
		}
		guard let row = controller.visibleRow(at: indexPath) else {
			// Well, I guess we're screwed
			return super.tableView(tableView, cellForRowAt: indexPath)
		}
		return row.cell
	}
	
	public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard tableView.estimatedRowHeight != UITableViewAutomaticDimension else {
			return UITableViewAutomaticDimension
		}
		guard let controller = staticTableViewController else {
			return super.tableView(tableView, heightForRowAt: indexPath)
		}
		guard let row = controller.visibleRow(at: indexPath) else {
			// Well, I guess we're screwed
			return super.tableView(tableView, heightForRowAt: indexPath)
		}
		guard let rowHeight = row.height else {
			return super.tableView(tableView, heightForRowAt: indexPath)
		}
		return rowHeight
	}
	
	public override func tableView(_ view: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard tableView.estimatedSectionHeaderHeight != UITableViewAutomaticDimension else {
			return UITableViewAutomaticDimension
		}
		let defaultHeight = super.tableView(view, heightForHeaderInSection: section)
		guard hideEmptySections else {
			return defaultHeight
		}
		guard let controller = staticTableViewController else {
			return defaultHeight
		}
		let section = controller.sections[section]
		guard section.rows.count > 0 else {
			return 0
		}
		return defaultHeight
	}
	
	public override func tableView(_ view: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard tableView.estimatedSectionFooterHeight != UITableViewAutomaticDimension else {
			return UITableViewAutomaticDimension
		}
		let defaultHeight = super.tableView(view, heightForFooterInSection: section)
		guard hideEmptySections else {
			return defaultHeight
		}
		guard let controller = staticTableViewController else {
			return defaultHeight
		}
		let section = controller.sections[section]
		guard section.rows.count > 0 else {
			return 0
		}
		return defaultHeight
	}
	
	public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let title = super.tableView(tableView, titleForHeaderInSection: section)
		guard let controller = staticTableViewController else {
			return title
		}
		guard hideEmptySections else {
			return title
		}
		let section = controller.sections[section]
		guard section.rows.count > 0 else {
			return nil
		}
		return title
	}
	
	public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let title = super.tableView(tableView, titleForFooterInSection: section)
		guard let controller = staticTableViewController else {
			return title
		}
		guard hideEmptySections else {
			return title
		}
		let section = controller.sections[section]
		guard section.rows.count > 0 else {
			return nil
		}
		return title
	}
}

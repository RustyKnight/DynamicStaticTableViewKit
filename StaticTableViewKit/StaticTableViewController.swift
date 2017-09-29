//
//  StaticDataTableViewController.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import UIKit

open class staticTableViewModel: UITableViewController {
  
  // MARK: Custom properties
  
	open var hideEmptySections: Bool = true
	open var animateSectionHeaders: Bool = true
	
	open var insertTableViewRowAnimation: UITableViewRowAnimation = .automatic
	open var deleteTableViewRowAnimation: UITableViewRowAnimation = .automatic
	open var reloadTableViewRowAnimation: UITableViewRowAnimation = .automatic
  
  public var staticTableViewModel: StaticTableViewModel?
  
  // MARK: Custom functionality

	open func cellIsHidden(_ cell: UITableViewCell) -> Bool {
    guard let controller = staticTableViewModel else {
      return false
    }
    guard let row = controller.row(with: cell) else {
      return false
    }
    return row.isHidden
	}
	
	open func update(cell: UITableViewCell...) {
    guard let controller = staticTableViewModel else {
      return
    }
    for aCell in cell {
      guard let row = controller.row(with: aCell) else {
        continue
      }
      row.update()
    }
	}
	
	open func cell(_ cell: UITableViewCell, hide: Bool) {
    guard let controller = staticTableViewModel else {
      return
    }
    guard let row = controller.row(with: cell) else {
      return
    }
    row.isHidden = hide
	}
	
	open func cell(_ cell: UITableViewCell..., height: CGFloat) {
    guard let controller = staticTableViewModel else {
      return
    }
    for aCell in cell {
      guard let row = controller.row(with: aCell) else {
        continue
      }
      row.height = height
    }
	}
	
	open func reloadData(animated: Bool) {
    guard let controller = staticTableViewModel else {
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
  
  open override func viewDidLoad() {
    super.viewDidLoad()

    do {
      staticTableViewModel = try StaticTableViewModel(tableView: tableView)
    } catch let error {
      print(error)
    }
  }
	
	// MARK: TableView Data Source
	
	open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let controller = staticTableViewModel else {
			return super.tableView(tableView, numberOfRowsInSection: section)
		}
		return controller.sections[section].numberOfVisibleRows
	}
	
	open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let controller = staticTableViewModel else {
			return super.tableView(tableView, cellForRowAt: indexPath)
		}
		guard let row = controller.visibleRow(at: indexPath) else {
			// Well, I guess we're screwed
			return super.tableView(tableView, cellForRowAt: indexPath)
		}
		return row.cell
	}
	
	open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		guard tableView.estimatedRowHeight != UITableViewAutomaticDimension else {
			return UITableViewAutomaticDimension
		}
		guard let controller = staticTableViewModel else {
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
	
	open override func tableView(_ view: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard tableView.estimatedSectionHeaderHeight != UITableViewAutomaticDimension else {
			return UITableViewAutomaticDimension
		}
		let defaultHeight = super.tableView(view, heightForHeaderInSection: section)
		guard hideEmptySections else {
			return defaultHeight
		}
		guard let controller = staticTableViewModel else {
			return defaultHeight
		}
		let section = controller.sections[section]
		guard section.rows.count > 0 else {
			return 0
		}
		return defaultHeight
	}
	
	open override func tableView(_ view: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard tableView.estimatedSectionFooterHeight != UITableViewAutomaticDimension else {
			return UITableViewAutomaticDimension
		}
		let defaultHeight = super.tableView(view, heightForFooterInSection: section)
		guard hideEmptySections else {
			return defaultHeight
		}
		guard let controller = staticTableViewModel else {
			return defaultHeight
		}
		let section = controller.sections[section]
		guard section.rows.count > 0 else {
			return 0
		}
		return defaultHeight
	}
	
	open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let title = super.tableView(tableView, titleForHeaderInSection: section)
		guard let controller = staticTableViewModel else {
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
	
	open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let title = super.tableView(tableView, titleForFooterInSection: section)
		guard let controller = staticTableViewModel else {
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

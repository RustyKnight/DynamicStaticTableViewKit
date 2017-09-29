//
//  StaticDataTableViewController.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import UIKit

public class StaticDataTableViewController: UITableViewController {
	public var hideEmptySections: Bool = true
	public var animateSectionHeaders: Bool = true
	
	public var insertTableViewRowAnimation: UITableViewRowAnimation = .automatic
	public var deleteTableViewRowAnimation: UITableViewRowAnimation = .automatic
	public var reloadTableViewRowAnimation: UITableViewRowAnimation = .automatic
	
	public func cellIsHidden(_ cell: UITableViewCell) {
		
	}
	
	public func update(cell: UITableViewCell...) {
		
	}
	
	public func cell(_ cell: UITableViewCell, hidden: Bool) {
		
	}
	
	public func cell(_ cell: UITableViewCell..., height: Bool) {
		
	}
	
	public func reloadData(animated: Bool) {
		
	}
}

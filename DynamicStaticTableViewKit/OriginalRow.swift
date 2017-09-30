//
//  OriginalRow.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import UIKit

enum BatchOperation {
	case none
	case insert
	case delete
	case update
}

public class OriginalRow {
	
	var isHidden: Bool {
		get {
			return isHiddenPlanned
		}
		
		set {
			print("isHiddenReal = \(isHiddenReal)")
			print("isHidden = \(newValue)")
			print("isHiddenPlanned = \(isHiddenPlanned)")
			if !isHiddenReal && newValue {
				batchOperation = .delete
			} else if isHiddenReal && !newValue {
				batchOperation = .insert
			}
			
			isHiddenPlanned = newValue
		}
	}
	
	var isHiddenReal: Bool = false
	var isHiddenPlanned: Bool = false
	var batchOperation: BatchOperation = .none
	let cell: UITableViewCell
	let indexPath: IndexPath
	var height: CGFloat? = nil // Not sure I want this
  
  init(indexPath: IndexPath, cell: UITableViewCell) {
    self.indexPath = indexPath
    self.cell = cell
  }
	
 func update() {
		guard !isHidden && batchOperation == .none else {
			return
		}
		batchOperation = .update
	}
	
}

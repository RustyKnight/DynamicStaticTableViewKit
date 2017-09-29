//
//  OriginalRow.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import Foundation

enum BatchOperation {
	case none
	case insert
	case delete
	case update
}

struct OriginalRow {
	
	var isHidden: Bool {
		get {
			return isHiddenPlanned
		}
		
		set {
			if !isHiddenReal && isHidden {
				batchOperation = .delete
			} else if isHiddenReal && !isHidden {
				batchOperation = .insert
			}
			
			isHiddenPlanned = isHidden
		}
	}
	
	var isHiddenReal: Bool = false
	var isHiddenPlanned: Bool = false
	var batchOperation: BatchOperation = .none
	let cell: UITableViewCell
	let indexPath: IndexPath
	var height: Float!
  
  init(indexPath: IndexPath, cell: UITableViewCell) {
    self.indexPath = indexPath
    self.cell = cell
  }
	
	mutating func update() {
		guard !isHidden && batchOperation == .none else {
			return
		}
		batchOperation = .update
	}
	
}

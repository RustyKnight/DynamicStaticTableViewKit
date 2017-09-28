//
//  OriginalRow.swift
//  StaticTableKit
//
//  Created by Shane Whitehead on 29/9/17.
//  Copyright © 2017 Shane Whitehead. All rights reserved.
//

import Foundation

public enum BatchOperation {
	case none
	case insert
	case delete
	case update
}

public struct OriginalRow {
	
	public var hidden: Bool {
		get {
			return hiddenPlanned
		}
		
		set {
			if !hiddenReal && hidden {
				batchOperation = .delete
			} else if hiddenReal && !hidden {
				batchOperation = .insert
			}
			
			hiddenPlanned = hidden
		}
	}
	
	var hiddenReal: Bool = false
	var hiddenPlanned: Bool = false
	public var batchOperation: BatchOperation = .none
	public var cell: UITableViewCell!
	public var indexPath: IndexPath!
	public var height: Float!
	
	mutating func update() {
		guard !hidden && batchOperation == .none else {
			return
		}
		batchOperation = .update
	}
	
}

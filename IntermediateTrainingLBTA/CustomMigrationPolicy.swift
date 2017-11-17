//
//  CustomMigrationPolicy.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 18..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
	
	// type our transform
	@objc func transformNumEmployeesForNum(forNum: NSNumber) -> String {
		if forNum.intValue < 150 {
			return "small"
		} else {
			return "very Large"
		}
	}
}

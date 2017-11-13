//
//  CompaniesController+CreateCompany.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 8..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
	func didEditCompany(company: Company) {
		// update my tableView somehow
		let row = companies.index(of: company)
		let reloadIndexPath = IndexPath(row: row!, section: 0)
		tableView.reloadRows(at: [reloadIndexPath], with: .middle)
	}
	
	func didAddCompany(company: Company) {
		companies.append(company)
		let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
		tableView.insertRows(at: [newIndexPath], with: .automatic)
	}
}

//
//  ViewController.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 10. 26..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
	
	
	var companies = [Company]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.companies = CoreDataManager.shared.fetchCompanies()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
		
		view.backgroundColor = .white
		navigationItem.title = "Companies"
		
 		setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
		
		
		tableView.backgroundColor = .darkBlue
		tableView.separatorColor = .white
		//		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView() // blank View
		tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellID")
		
	}
	
	/// Reset all Company Objects
	@objc private func handleReset() {
		print("delete all objects")
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		//		companies.forEach { company in
		//			context.delete(company)
		//		}
		
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
		
		do {
			try context.execute(batchDeleteRequest)
			
			// upon deletion from core data succeeded
			var indexPathsToRemove = [IndexPath]()
			for (index, _) in companies.enumerated() {
				let indexPath = IndexPath(row: index, section: 0)
				indexPathsToRemove.append(indexPath)
			}
			companies.removeAll()
			tableView.deleteRows(at: indexPathsToRemove, with: .left)
			
			
		} catch let err {
			print("Failed to delete objects from core Data: ", err)
		}
		
	}
	
	@objc private func didTapAdd() {
		//		addCompany()
	}
	@objc private func handleAddCompany() {
		print("adding Company")
		
		let createCompanyController = CreateCompanyController()
		createCompanyController.delegate = self
		
		let navController = CustomNavigationController(rootViewController: createCompanyController)
		
		present(navController, animated: true, completion: nil)
	}
	
	
}

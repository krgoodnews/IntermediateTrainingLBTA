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

	
	@objc private func doNestedUpdates() {
		print("Trying to perform nested updates now...")
		
		DispatchQueue.global(qos: .background).async {
			let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
			
			privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
			
			// execute update on privateContext now
			let request: NSFetchRequest<Company> = Company.fetchRequest()
			request.fetchLimit = 1
			do {
				let companies = try privateContext.fetch(request)
				
				companies.forEach({ (company) in
					print(company.name ?? "")
					company.name = "D: \(company.name ?? "")"
					
					do {
						try privateContext.save()
						
						DispatchQueue.main.async {
							self.tableView.reloadData()
						}
					} catch let saveErr {
						print("Failed to save on private context:", saveErr)
					}
				})
			} catch let fetchErr {
				print("Failed to fetch on private context: ", fetchErr)
			}

		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.companies = CoreDataManager.shared.fetchCompanies()
		
		navigationItem.leftBarButtonItems = [
			UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
			UIBarButtonItem(title: "Nested Update", style: .plain, target: self, action: #selector(doNestedUpdates))
		]
		
		view.backgroundColor = .white
		navigationItem.title = "Companies"
		
 		setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
		
		
		tableView.backgroundColor = .darkBlue
		tableView.separatorColor = .white
		//		tableView.separatorStyle = .none
		tableView.tableFooterView = UIView() // blank View
		tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellID")
		
	}
	
	
	/// background thread
	@objc private func doUpdates() {
		print("Trying to do update companies on a background context...")

		CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
			
			let request: NSFetchRequest<Company> = Company.fetchRequest()
			
			do {
				let companies = try backgroundContext.fetch(request)
				companies.forEach({ (company) in
					print(company.name ?? "")
					company.name = "C: \(company.name ?? "")"
				})
				
				do {
					try backgroundContext.save()
					
					// let's try to update the UI after a save
					DispatchQueue.main.async {
						
						// reset will forget all of the objects you've fetch before
						CoreDataManager.shared.persistentContainer.viewContext.reset()
						
						// you don't want to refetch everything if you're just simply update on or two companies
						self.companies = CoreDataManager.shared.fetchCompanies()
						
						// is there a way to just merge the changes that you made onto the main view context?
						
						self.tableView.reloadData()
					}
				} catch let saveErr {
					print("Failed to save on background:", saveErr)
				}
			} catch let err {
				print("Failed to fetch companies on background:", err)
			}
		}
	}
	
	/// Reset all Company Objects
	@objc private func handleReset() {
		print("delete all objects")
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		
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

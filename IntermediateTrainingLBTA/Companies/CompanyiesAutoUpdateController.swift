//
//  CompanyiesAutoUpdateController.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 17..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit
import CoreData
import Then

class CompanyiesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	// warning: this code here is going to be a bit of a monster
	
	lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		let request: NSFetchRequest<Company> = Company.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: "name", ascending: true)
		]
		
		let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
		
		frc.delegate = self
		
		do {
			try frc.performFetch()
		} catch let err {
			print(err)
		}
		
		return frc
	}()
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		switch type {
		case .insert:
			tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
		case .delete:
			tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
		case .move:
			break
		case .update:
			break
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .fade)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .fade)
		case .update:
			tableView.reloadRows(at: [indexPath!], with: .fade)
		case .move:
			tableView.moveRow(at: indexPath!, to: newIndexPath!)
		}
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	
	@objc private func handleAdd() {
		print("Let's add a company called BMW")
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		let company = Company(context: context)
		company.name = "BMW"
		
		try? context.save()
	}
	
	@objc private func handleDelete() {
		let request: NSFetchRequest<Company> = Company.fetchRequest()
		
//		request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		let companiesWithB = try? context.fetch(request)
		
		companiesWithB?.forEach { (company) in
			context.delete(company)
		}
		
		try? context.save()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Company Auto Updates"
		
		navigationItem.leftBarButtonItems = [
			UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)),
			UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
		]
		
		tableView.backgroundColor = .darkBlue
		tableView.register(CompanyCell.self, forCellReuseIdentifier: cellID)

		fetchedResultsController.fetchedObjects?.forEach({ (company) in
			print(company.name ?? "")
		})
		
	}
	
	// MARK: TableView
	let cellID = "cellID"
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let label = IndentedLabel().then {
			$0.text = fetchedResultsController.sectionIndexTitles[section]
			$0.backgroundColor = .lightBlue
		}
		return label
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
		return sectionName
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedResultsController.sections![section].numberOfObjects
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CompanyCell
		
		let company = fetchedResultsController.object(at: indexPath)
	
		cell.company = company
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}

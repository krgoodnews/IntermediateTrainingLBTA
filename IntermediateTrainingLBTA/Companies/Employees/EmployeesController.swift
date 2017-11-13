//
//  EmployeesController.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 9..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
	func didAddEmployee(employee: Employee) {
		employees.append(employee)
		tableView.reloadData()
	}
	
	
	var company: Company?
	var employees = [Employee]()
	
	var cellID = "employeeCellID"
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company?.name
	}
	
	private func fetchEmployees() {
//		print("trying to fetch employees...")
//
//		let context = CoreDataManager.shared.persistentContainer.viewContext
//
//		let request = NSFetchRequest<Employee>(entityName: "Employee")
//
//
//		do {
//			let employees = try context.fetch(request)
//			self.employees = employees
//
//			employees.forEach({ (employee) in
//				print("Employee Name: ", employee.name ?? "")
//			})
//		} catch let err {
//			print("Failed to fetch employees:", err)
//		}
		guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
		self.employees = companyEmployees
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchEmployees()
		
		tableView.backgroundColor = .darkBlue
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		
		setupPlusButtonInNavBar(selector: #selector(handleAdd))
	}
	
	@objc private func handleAdd() {
		print("Trying add employee...")
		
		let createEmployeeController = CreateEmployeeController()
		createEmployeeController.delegate = self
		createEmployeeController.company = company
		let navController = UINavigationController(rootViewController: createEmployeeController)
		present(navController, animated: true, completion: nil)
	}
	
	// MARK: TableView
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return employees.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let employee = employees[indexPath.row]
		cell.textLabel?.text = employee.name
		
		
		if let taxID = employee.employeeInformation?.taxID {
			cell.textLabel?.text = "\(employee.name ?? "")   \(taxID)"
		}
		
		cell.backgroundColor = .teal
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = .boldSystemFont(ofSize: 15)
		
		return cell
	}
}

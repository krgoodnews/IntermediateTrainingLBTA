//
//  EmployeesController.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 9..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit
import CoreData

// lets create a UILabel subclass for custom text drawing
class IndentedLabel: UILabel {
	/// 왼쪽에 간격 두는 라벨
	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
		let customRect = UIEdgeInsetsInsetRect(rect, insets)
		super.drawText(in: customRect)
	}
	
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
	func didAddEmployee(employee: Employee) {
//		fetchEmployees()
//		tableView.reloadData()
		
		// what is the insertion index path?
		guard let section = employeeTypes.index(of: employee.type!) else { return }
		let row = allEmployees[section].count 	// what is my row?
		let insertionIndexPath = IndexPath(row: row, section: section)
		allEmployees[section].append(employee)
		tableView.insertRows(at: [insertionIndexPath], with: .middle)
	}
	
	
	var company: Company?
//	var employees = [Employee]()
	
	var cellID = "employeeCellID"
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationItem.title = company?.name
	}

	var allEmployees = [[Employee]]()
	
	var employeeTypes = [
		EmployeeType.Intern.rawValue,
		EmployeeType.Executive.rawValue,
		EmployeeType.SeniorManagement.rawValue,
		EmployeeType.Staff.rawValue
	]
	
	private func fetchEmployees() {
		
		allEmployees = []
		
		guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
		
		// let's use my array and loop to filter instead
		employeeTypes.forEach { (employeeType) in
			let elements = companyEmployees.filter { $0.type == employeeType }
			allEmployees.append(elements)
		}
		
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
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return allEmployees.count
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let cell = UITableViewCell().then {
			$0.textLabel?.text = employeeTypes[section]
//			$0.textLabel?.backgroundColor = .lightBlue
			$0.backgroundColor = .lightBlue
			$0.textLabel?.textColor = .darkBlue
			$0.textLabel?.font = .boldSystemFont(ofSize: 16)
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}
	

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allEmployees[section].count
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		
		let employee = allEmployees[indexPath.section][indexPath.row]
		
		cell.textLabel?.text = employee.fullName
		

		if let birthday = employee.employeeInformation?.birthDay {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			cell.textLabel?.text = "\(employee.fullName ?? "")     \(dateFormatter.string(from: birthday))"
		}
//		if let taxID = employee.employeeInformation?.taxID {
//			cell.textLabel?.text = "\(employee.name ?? "")   \(taxID)"
//		}
		
		cell.backgroundColor = .teal
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = .boldSystemFont(ofSize: 15)
		
		return cell
	}
}

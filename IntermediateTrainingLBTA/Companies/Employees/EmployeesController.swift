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
	
	var shortNameEmployees = [Employee]()
	var longNameEmployees = [Employee]()
	var reallyLongNameEmployees = [Employee]()
	
	var allEmployees = [[Employee]]()
	
	private func fetchEmployees() {
		guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
		
		shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
			if let count = employee.name?.count {
				return count < 6
			}
			return false
		})
		
		longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
			if let count = employee.name?.count {
				return count >= 6 && count <= 9
			}
			return false
		})
		
		reallyLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
			if let count = employee.name?.count {
				return count > 9
			}
			return false
		})
		
		allEmployees = [shortNameEmployees, longNameEmployees, reallyLongNameEmployees]
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
		let label = IndentedLabel().then {
			if section == 0 {
				$0.text = "Short Names"
			} else if section == 1 {
				$0.text = "Long Names"
			} else {
				$0.text = "Really Long Names"
			}
			$0.backgroundColor = .lightBlue
			$0.textColor = .darkBlue
			$0.font = .boldSystemFont(ofSize: 16)
		}
		return label
	}
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	

	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allEmployees[section].count
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		
		let employee = allEmployees[indexPath.section][indexPath.row]
		
		cell.textLabel?.text = employee.name
		

		if let birthday = employee.employeeInformation?.birthDay {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd, yyyy"
			cell.textLabel?.text = "\(employee.name ?? "")     \(dateFormatter.string(from: birthday))"
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

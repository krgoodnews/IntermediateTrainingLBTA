//
//  CreateEmployeeController.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 9..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit
import Then

protocol CreateEmployeeControllerDelegate {
	func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
	
	var company: Company?
	
	var delegate: CreateEmployeeControllerDelegate?
	
	let nameLabel = UILabel().then {
		$0.text = "Name"
		$0.translatesAutoresizingMaskIntoConstraints = false
	}
	let nameTextField = UITextField().then {
		$0.placeholder = "Enter name"
		$0.translatesAutoresizingMaskIntoConstraints = false
	}
	
	let birthdayLabel = UILabel().then {
		$0.text = "Birthday"
		$0.translatesAutoresizingMaskIntoConstraints = false
	}
	let birthdayTextField = UITextField().then {
		$0.placeholder = "MM/DD/YYYY"
		$0.translatesAutoresizingMaskIntoConstraints = false
	}
	
	let employeeTypeSegmentedControl = UISegmentedControl(items: [
		EmployeeType.Executive.rawValue,
		EmployeeType.SeniorManagement.rawValue,
		EmployeeType.Staff.rawValue,
		EmployeeType.Intern.rawValue
		]).then {
		$0.selectedSegmentIndex = 0
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.tintColor = .darkBlue
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Create Employee"
		
		setupCancelButton()
		
		view.backgroundColor = .darkBlue
		
		setupUI()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
	}
	
	@objc private func handleSave() {
		guard let name = nameTextField.text else { return }
		guard let company = self.company else { return }

		// turn birthdayTF.text into a date object
		guard let birthdayText = birthdayTextField.text else { return }
		
		// let's perform the validation step here
		if birthdayText.isEmpty {
			showError(title: "Empty Birthday", message: "You have not entered a birthday")
			return
		}
		
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		guard let birthdatDate = dateFormatter.date(from: birthdayText) else {
			showError(title: "Bad Date", message: "Birthday date entered not valid")

			return
		}
		
		
		guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
		
		
		// where do we get company from?
		let tuple = CoreDataManager.shared.createEmployee(employeeName: name, employeeType: employeeType, birthday: birthdatDate, company: company)
		
		if let error = tuple.1 {
			print(error)
		} else {
			// creation success
			dismiss(animated: true, completion: {
				// we'll call the delegate
				self.delegate?.didAddEmployee(employee: tuple.0!)
			})
		}
	}
	
	private func showError(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(alertController, animated: true, completion: nil)
		return
	}
	
	private func setupUI() {
		_ = setupLightBlueBackgroundView(height: 150)
		
		
		
		view.addSubview(nameLabel)
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(nameTextField)
		nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
		nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
		nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
		
		view.addSubview(birthdayLabel)
		birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(birthdayTextField)
		birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
		birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
		birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		birthdayTextField.heightAnchor.constraint(equalTo: birthdayLabel.heightAnchor).isActive = true
		
		
		view.addSubview(employeeTypeSegmentedControl)
		employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
		employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
		employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
	}
}

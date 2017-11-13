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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Create Employee"
		
		setupCancelButton()

		
		view.backgroundColor = .darkBlue
		
		_ = setupLightBlueBackgroundView(height: 50)
		setupUI()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
	}
	
	@objc private func handleSave() {
		guard let name = nameTextField.text else { return }
		guard let company = self.company else { return }
		
		// where do we get company from?
		
		let tuple = CoreDataManager.shared.createEmployee(employeeName: name, company: company)
		
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
	
	private func setupUI() {
		
		view.addSubview(nameLabel)
		nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		//		nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(nameTextField)
		nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
		nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
		nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
		
	}
}

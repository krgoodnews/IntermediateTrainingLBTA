//
//  CreateCompanyController.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 10. 26..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit
import Then
import CoreData

// Custom Delegation
protocol CreateCompanyControllerDelegate {
	func didAddCompany(company: Company)
	func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	var company: Company? = nil {
		didSet {
			nameTextField.text = company?.name

			setupCircularImgStyle()
			
			if let imgData = company?.imageData {
				companyImgView.image = UIImage(data: imgData)
			}
			
			if let foundedDate = company?.founded {
				datePicker.date = foundedDate
			}
		}
	}
	
	private func setupCircularImgStyle() {
		
		companyImgView.layer.cornerRadius = companyImgView.frame.width / 2
		companyImgView.layer.borderColor = UIColor.darkBlue.cgColor
		companyImgView.layer.borderWidth = 2
		companyImgView.clipsToBounds = true
	}
	
	
	// not tightly-coupled
	var delegate: CreateCompanyControllerDelegate?
	
	lazy var companyImgView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty")).then {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.isUserInteractionEnabled = true
		$0.contentMode = .scaleAspectFit
		$0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
	}
	
	@objc private func handleSelectPhoto() {
		print("Trying to select photo...")
		
		let imgPickerController = UIImagePickerController()
		
		imgPickerController.delegate = self
		imgPickerController.allowsEditing = true
		
		present(imgPickerController, animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		print(info)
		
		if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage {
			companyImgView.image = editedImg
		} else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
			companyImgView.image = originalImg
		}
		
		setupCircularImgStyle()
		
		dismiss(animated: true, completion: nil)
		
	}
	
	let nameLabel = UILabel().then {
		$0.text = "Name"
		$0.translatesAutoresizingMaskIntoConstraints = false
	}
	let nameTextField = UITextField().then {
		$0.placeholder = "Enter name"
		$0.translatesAutoresizingMaskIntoConstraints = false
	}
	
	let datePicker = UIDatePicker().then {
		$0.datePickerMode = .date
		$0.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func fetchCompanies() {
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
		// ternary syntax
		navigationItem.title = company == nil ? "Create Company" : "Edit Company"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchCompanies()
		
		setupUI()
		
		setupCancelButton()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
		
		view.backgroundColor = .darkBlue
	}
	
	private func setupUI() {

		let lightBlueBackgroundView = setupLightBlueBackgroundView(height: 350)
		
		view.addSubview(companyImgView)
		companyImgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
		companyImgView.heightAnchor.constraint(equalToConstant: 100).isActive = true
		companyImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		companyImgView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		

		view.addSubview(nameLabel)
		nameLabel.topAnchor.constraint(equalTo: companyImgView.bottomAnchor).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		//		nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
		
		view.addSubview(nameTextField)
		nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
		nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
		nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		nameTextField.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
		
		
		// setup DatePicker
		view.addSubview(datePicker)
		datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
		datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
	}
	
	@objc private func didTapSave() {
		if company == nil {
			createCompany()
		} else {
			saveCompanyChanges()
		}
	}
	
	private func saveCompanyChanges() {
		let context = CoreDataManager.shared.persistentContainer.viewContext
		company?.name = nameTextField.text
		company?.founded = datePicker.date
		
		if let companyImg = companyImgView.image {
			let imgData = UIImageJPEGRepresentation(companyImg, 0.8)
			company?.imageData = imgData
		}
		
		do {
			try context.save()
			
			dismiss(animated: true, completion: {
				self.delegate?.didEditCompany(company: self.company!)
			})
		} catch let saveErr {
			print("Failed to save company changes:", saveErr)
		}
		
		
	}
	
	private func createCompany() {
		print("Trying to save company...")
		
		let context = CoreDataManager.shared.persistentContainer.viewContext
		
		let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
		
		company.setValue(nameTextField.text, forKey: "name")
		company.setValue(datePicker.date, forKey: "founded")
		
		if let companyImg = companyImgView.image {
			let imgData = UIImageJPEGRepresentation(companyImg, 0.8)
			company.setValue(imgData, forKey: "imageData")
		}
		
		do {
			try context.save()
			
			self.dismiss(animated: true) {
				self.delegate?.didAddCompany(company: company as! Company)
			}
			
			
		} catch let saveErr {
			print("저장 실패", saveErr)
		}
		
		
		
		
		//		dismiss(animated: true) {
		//			guard let name = self.nameTextField.text else { return }
		//
		//			let company = Company(name: name, founded: Date())
		//			self.delegate?.didAddCompany(company: company)
		//		}
	}
	
	
	
}

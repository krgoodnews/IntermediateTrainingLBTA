//
//  CoreDataManager.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 10. 28..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import CoreData

struct CoreDataManager {
	
	static let shared = CoreDataManager() // will live forever as long as your app is still alive, it's properties will too
	
	let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "IntermediateTraningDateModel")
		container.loadPersistentStores { (storeDescription, err) in
			if let err = err {
				fatalError("Loading of store failed: \(err)")
			}
		}
		return container
	}()
	
	
	func fetchCompanies() -> [Company] {
		// initialization of our Core Data Stack
		let context = persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
		
		do {
			let companies = try context.fetch(fetchRequest)
			
			return companies
			
		} catch let err {
			print("불러오기 실패: ", err)
			return []
		}
		
	}
	
	func createEmployee(employeeName: String, birthday: Date, company: Company) -> (Employee?, Error?) {
		let context = persistentContainer.viewContext
		
		// create an employee
		let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
		
		employee.company = company
		// let check company is setup correctly
//		let company = Company(context: context)
		
		
		employee.setValue(employeeName, forKey: "name")
		
		let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
		
		employeeInformation.taxID = "456"
		employeeInformation.birthDay = birthday
		
		employee.employeeInformation = employeeInformation
		
		do {
			try context.save()
			return (employee, nil)
		} catch let err {
			print("error at create Employee:", err)
			return (nil, err)
		}
		
	}
}

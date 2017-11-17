//
//  Service.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 17..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import Foundation

struct Service {

	static let shared = Service()
	
	let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
	
	func downloadCompaniesFromServer() {
		print("Attempting to download companies...")
		
		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { (data, resp, err) in
			print("Finished Downloading")
			
			if let err = err {
				print("Failed to download companies: ", err)
				return
			}
			
			guard let data = data else { return }
			
			let jsonDecoder = JSONDecoder()
			
			
			do {
				// I'll leave a link in the bottom if you want more details on how JSON decodable works
				let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
				
				jsonCompanies.forEach({ (jsonCompany) in
					print(jsonCompany.name)
					jsonCompany.employees?.forEach({ (jsonEmployee) in
						
						print("    \(jsonEmployee.name)")
					})
				})
			} catch let err {
				print("Failed to decode: ", err)
			}
//			let string = String(data: data, encoding: .utf8)
			
			
			
		}.resume() // please don't forget to make this call
		
	}
}

struct JSONCompany: Decodable {
	let name: String
	let founded: String
	var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
	let name: String
	let type: String
	let birthday: String
}

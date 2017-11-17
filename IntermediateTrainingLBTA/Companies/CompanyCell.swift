//
//  CompanyCell.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 8..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit
import Then

class CompanyCell: UITableViewCell {
	
	var company: Company? {
		didSet {
			nameFoundedDateLabel.text = company?.name
			if let imgData = company?.imageData {
				companyImgView.image = UIImage(data: imgData)
			} else {
				companyImgView.image = #imageLiteral(resourceName: "select_photo_empty")
			}
			
			if let name = company?.name, let founded = company?.founded {
				let formatter = DateFormatter()
				formatter.dateFormat = "MMM dd, yyyy"
				let foundedDateString = formatter.string(from: founded)
				let dateString = "\(name) - Founded: \(foundedDateString)"
				nameFoundedDateLabel.text = dateString
			} else {
				nameFoundedDateLabel.text = company?.name
				
				nameFoundedDateLabel.text = "\(company?.name ?? "") \(company?.numEmployees ?? "")"
			}
		}
	}
	
	// you can't declare another img view using "imageView"
	let companyImgView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty")).then {
		$0.contentMode = .scaleAspectFill
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.layer.cornerRadius = 20
		$0.clipsToBounds = true
		$0.layer.borderColor = UIColor.darkBlue.cgColor
		$0.layer.borderWidth = 1
	}
	
	let nameFoundedDateLabel = UILabel().then {
		$0.text = "COMPANY NAME"
		$0.font = .boldSystemFont(ofSize: 16)
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.textColor = .white
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		backgroundColor = .teal
		
		addSubview(companyImgView)
		companyImgView.heightAnchor.constraint(equalToConstant: 40).isActive = true
		companyImgView.widthAnchor.constraint(equalToConstant: 40).isActive = true
		companyImgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		companyImgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		
		
		addSubview(nameFoundedDateLabel)
		nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImgView.rightAnchor, constant: 8).isActive = true
		nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

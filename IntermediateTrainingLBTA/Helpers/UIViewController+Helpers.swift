//
//  UIViewController+Helpers.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 11. 9..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit

extension UIViewController {
	
	// my extension / helper methods
	
	func setupPlusButtonInNavBar(selector: Selector) {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
	}
	
	func setupCancelButton() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
	}
	
	@objc func handleCancelModal() {
		dismiss(animated: true, completion: nil)
	}
	
	
	func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
		let lightBlueBackgroundView = UIView().then {
			$0.backgroundColor = .lightBlue
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		view.addSubview(lightBlueBackgroundView)
		
		lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
		
		return lightBlueBackgroundView
	}
}

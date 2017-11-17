//
//  AppDelegate.swift
//  IntermediateTrainingLBTA
//
//  Created by Goodnews on 2017. 10. 26..
//  Copyright © 2017년 goodnews. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

extension UINavigationController {
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		

		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().isTranslucent = false
		
		UINavigationBar.appearance().barTintColor = .lightRed
		UINavigationBar.appearance().prefersLargeTitles = true
		
		UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		
		
		// 초기세팅
		window = UIWindow()
		window?.makeKeyAndVisible()
		
		let companiesController = CompanyiesAutoUpdateController()
		let navController = CustomNavigationController(rootViewController: companiesController)
		window?.rootViewController = navController
		
		return true
	}
}


//
//  DriverTabBarController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import UIKit

class DriverTabBarController: UITabBarController {

  override func viewDidLoad() {
    
    let mainVC = DriverMainViewController(nibName:"DriverMainViewController", bundle: .main)
    mainVC.tabBarItem = UITabBarItem(
      title: "title.main".localized,
      image: UIImage(named: "home"),
      tag: 0
    )
    
    let profileVC = DriverProfileViewController(nibName:"DriverProfileViewController", bundle: .main)
    profileVC.tabBarItem = UITabBarItem(
      title: "title.profile".localized,
      image: UIImage(named: "profile"),
      tag: 1
    )
    
    let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)]
    UINavigationBar.appearance().titleTextAttributes = attributes
    UINavigationBar.appearance().tintColor = .black
    
    viewControllers = [mainVC, profileVC].map {
      UINavigationController(rootViewController: $0)
    }
  }
}



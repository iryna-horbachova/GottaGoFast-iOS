//
//  DriverProfileViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import UIKit

class DriverProfileViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "title.profile".localized
    navigationController?.navigationBar.prefersLargeTitles = true
  }

}

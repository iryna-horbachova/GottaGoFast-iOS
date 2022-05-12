//
//  ClientProfileViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import UIKit

class ClientProfileViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "title.profile".localized
    navigationController?.navigationBar.prefersLargeTitles = true
  }

}

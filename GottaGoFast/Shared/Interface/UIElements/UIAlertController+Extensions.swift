//
//  UIAlertController+Extensions.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import UIKit

extension UIAlertController {

  static func alertWithOKAction(title: String, message: String) -> UIAlertController {
    let title = NSLocalizedString(
      "ERROR_TITLE",
      value: title,
      comment: "Generic error title")
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
  
    return alertController
  }
}

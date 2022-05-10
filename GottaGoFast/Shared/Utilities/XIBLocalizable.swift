//
//  XIBLocalizable.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import UIKit

protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
  @IBInspectable var xibLocKey: String? {
    get { return nil }
    set(key) {
      text = key?.localized
    }
  }
}
extension UIButton: XIBLocalizable {
  @IBInspectable var xibLocKey: String? {
    get { return nil }
    set(key) {
      setTitle(key?.localized, for: .normal)
    }
  }
}

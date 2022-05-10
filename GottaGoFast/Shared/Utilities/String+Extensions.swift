//
//  String+Extensions.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
  var localized: String {
    NSLocalizedString(self, comment: "")
  }
}

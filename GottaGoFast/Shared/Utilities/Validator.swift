//
//  Validator.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

struct Validator {
  static func isValid(name: String) -> Bool {
    guard name.count > 2, name.count < 21 else { return false }

    let nameRegEx = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
    return name.range(of: nameRegEx, options: .regularExpression) != nil
  }

  static func isValid(number: String) -> Bool {
    let phoneNumRegEx = "[0-9]+"
    return number.range(of: phoneNumRegEx, options: .regularExpression) != nil
  }

  static func isValid(email: String) -> Bool {
    let emailRegEx = ".+\\@.+\\..+"
    return email.range(of: emailRegEx, options: .regularExpression) != nil
  }

  static func isValid(birthday: Date) -> Bool {
    let today = Date()
    return birthday < today
  }
}

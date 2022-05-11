//
//  UserRegistration.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 11.05.2022.
//

import Foundation

struct UserRegistration: Codable {
  let email: String
  let firstName: String
  let lastName: String
  let gender: String?
  let phoneNumber: String
  let birthDate: String?
}

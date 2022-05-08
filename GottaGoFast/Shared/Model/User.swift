//
//  User.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import Foundation

struct User: Codable {
  let email: String
  let firstName: String
  let lastName: String
  let gender: String
  let phoneNumber: String
  let birthdate: String?
}

//
//  ClientRegistration.swift
//  GottaGoFastClient
//
//  Created by Iryna Horbachova on 11.05.2022.
//

import Foundation

struct ClientRegistration: Codable {
  let user: UserRegistration
  let rideDiscount: Double?
  let password: String
  let confirmPassword: String
}

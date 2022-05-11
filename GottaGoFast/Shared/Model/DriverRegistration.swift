//
//  DriverRegistration.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 11.05.2022.
//

import Foundation

struct DriverRegistration: Codable {
  let user: UserRegistration
  let vehicle: Vehicle
  let password: String
  let confirmPassword: String
  let passportNumber: String
  let driverLicenseNumber: String
  let taxiLicenseNumber: String
}

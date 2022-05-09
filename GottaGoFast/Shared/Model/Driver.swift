//
//  Driver.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import Foundation

struct Driver: Codable {
  let id: String?
  let user: User
  let vehicle: Vehicle
  let passportNumber: String
  let driverLicenseNumber: String
  let taxiLicenseNumber: String
  let status: String
  
}

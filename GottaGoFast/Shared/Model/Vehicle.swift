//
//  Vehicle.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import Foundation

struct Vehicle: Codable {
  let model: String
  let type: String
  let category: String
  let insurancePolicyNumber: String
  let adultsSeatsNumber: Int
  let childrenSeatsNumber: Int
  let animalSeatsNumber: Int
  let trunkCapacity: Int
  let airConditionerPresent: Bool
}

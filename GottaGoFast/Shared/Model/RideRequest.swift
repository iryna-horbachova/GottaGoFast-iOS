//
//  RideRequest.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import Foundation

struct RideRequest: Codable {
  let id: Int?
  let clientId: Int
  let startLocationLatitude: Double
  let startLocationLongitude: Double
  let endLocationLatitude: Double
  let endLocationLongitude: Double
  let adultsSeatsNumber: Int
  let childrenSeatsNumber: Int
  let animalSeatsNumber: Int
  let trunkCapacity: Int
  let airConditionerPresent: Bool
}

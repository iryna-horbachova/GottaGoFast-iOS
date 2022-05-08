//
//  DesignatedRide.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import Foundation

struct DesignatedRide: Codable {
  let driverId: Int
  let requestRideId: Int
  let price: Double
  let status: String
}

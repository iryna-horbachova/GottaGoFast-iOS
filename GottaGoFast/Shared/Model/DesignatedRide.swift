//
//  DesignatedRide.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import Foundation

struct DesignatedRide: Codable, Equatable {
  let id: Int
  let driverId: Int
  let rideRequestId: Int
  let price: Double
  let status: String
  
  static func == (lhs: DesignatedRide, rhs: DesignatedRide) -> Bool {
    return lhs.id == rhs.id &&
           lhs.rideRequestId == rhs.rideRequestId &&
           lhs.status == rhs.status
  }
}

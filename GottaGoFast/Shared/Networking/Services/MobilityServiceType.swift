//
//  MobilityServiceType.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

protocol MobilityServiceType {
  func createRideRequest(
    _ rideRequest: RideRequest,
    completion: @escaping (Result <RideRequest, NetworkingError>) -> Void
  )

  func getDesignatedRideDetailForClient(
    rideRequestId: Int,
    completion: @escaping (Result <DesignatedRide?, NetworkingError>) -> Void
  )

  func getDesignatedRideDetailForDriver(
    driverId: Int,
    completion: @escaping (Result <DesignatedRide?, NetworkingError>) -> Void
  )

  func updateUserLocation(
    location: Geotag,
    completion: @escaping (Result <EmptyResult, NetworkingError>) -> Void
  )

  func getLatestUserLocation(
    userId: Int,
    completion: @escaping (Result <Geotag, NetworkingError>) -> Void
  )
}

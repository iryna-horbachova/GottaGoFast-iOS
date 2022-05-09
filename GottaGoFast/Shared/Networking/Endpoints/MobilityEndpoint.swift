//
//  MobilityEndpoint.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

enum MobilityEndpoint {
  case createRideRequest(_ rideRequest: RideRequest)
  case getDesignatedRideDetailForClient(rideRequestId: Int)
  case getDesignatedRideDetailForDriver(driverId: Int)
  case updateUserLocation(location: Geotag)
  case getLatestUserLocation(userId: Int)
}

extension MobilityEndpoint: EndpointType {
  var path: String {
    switch self {
    case .createRideRequest:
      return ":8080/api/mobility/rides/request/create/"
    case .getDesignatedRideDetailForClient(let requestRideId):
      return ":8080/api/mobility/rides/designated/requested_ride/\(requestRideId)/"
    case .getDesignatedRideDetailForDriver(let driverId):
      return ":8080/api/mobility/rides/designated/requested_ride_/driver/\(driverId)/"
    case .updateUserLocation:
      return ":8080/api/mobility/location/update/"
    case .getLatestUserLocation(let userId):
      return ":8080/api/mobility/location/get/\(userId)/"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .createRideRequest:
      return .post
    case .getDesignatedRideDetailForClient:
      return .get
    case .getDesignatedRideDetailForDriver:
      return .get
    case .updateUserLocation:
      return .post
    case .getLatestUserLocation:
      return .get
    }
  }

  var headers: [String : String]? {
    return nil
  }

  var needsAuthorization: Bool {
    return true
  }

  var body: Encodable? {
    switch self {
    case .createRideRequest(let rideRequest):
      return rideRequest
    case .getDesignatedRideDetailForClient:
      return nil
    case .getDesignatedRideDetailForDriver:
      return nil
    case .updateUserLocation(let geotag):
      return geotag
    case .getLatestUserLocation:
      return nil
    }
  }
}

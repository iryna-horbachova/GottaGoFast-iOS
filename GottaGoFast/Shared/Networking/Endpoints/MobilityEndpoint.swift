//
//  MobilityEndpoint.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

enum MobilityEndpoint {
  case createRideRequest(_ rideRequest: RideRequest)
  case getRideRequest(id: Int)
  case getDesignatedRideDetailForClient(rideRequestId: Int)
  case getDesignatedRideDetailForDriver(driverId: Int)
  case updateUserLocation(location: Geotag)
  case getLatestUserLocation(userId: Int)
  case updateDesignatedRideStatus(id: Int, status: String)
}

extension MobilityEndpoint: EndpointType {
  var path: String {
    switch self {
    case .createRideRequest:
      return ":8080/api/mobility/rides/request/create/"
    case .getRideRequest(let id):
      return ":8080/api/mobility/rides/request/\(id)/"
    case .getDesignatedRideDetailForClient(let requestRideId):
      return ":8080/api/mobility/rides/designated/requested_ride/\(requestRideId)/"
    case .getDesignatedRideDetailForDriver(let driverId):
      return ":8080/api/mobility/rides/designated/requested_ride_/driver/\(driverId)/"
    case .updateUserLocation:
      return ":8080/api/mobility/location/update/"
    case .getLatestUserLocation(let userId):
      return ":8080/api/mobility/location/get/\(userId)/"
    case .updateDesignatedRideStatus(let id, _):
      return ":8080/api/mobility/ride/designated/status/\(id)/"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .createRideRequest:
      return .post
    case .getRideRequest:
      return .get
    case .getDesignatedRideDetailForClient:
      return .get
    case .getDesignatedRideDetailForDriver:
      return .get
    case .updateUserLocation:
      return .post
    case .getLatestUserLocation:
      return .get
    case .updateDesignatedRideStatus:
      return .put
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
    case .getRideRequest:
      return nil
    case .getDesignatedRideDetailForClient:
      return nil
    case .getDesignatedRideDetailForDriver:
      return nil
    case .updateUserLocation(let geotag):
      return geotag
    case .getLatestUserLocation:
      return nil
    case .updateDesignatedRideStatus(_, let status):
      return ["status": status]
    }
  }
}

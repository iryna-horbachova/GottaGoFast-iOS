//
//  MobilityService.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

final class MobilityService: NetworkingService, MobilityServiceType {
  func createRideRequest(
    _ rideRequest: RideRequest,
    completion: @escaping (Result<RideRequest, NetworkingError>) -> Void
  ) {
    provider.request(MobilityEndpoint.createRideRequest(rideRequest)) {
      (result: Result<RideRequest, NetworkingError>) in

      switch result {
      case .success(let rideRequest):
        completion(.success(rideRequest))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func getDesignatedRideDetailForClient(
    rideRequestId: Int,
    completion: @escaping (Result<DesignatedRide?, NetworkingError>) -> Void
  ) {
    provider.request(MobilityEndpoint.getDesignatedRideDetailForClient(rideRequestId: rideRequestId)) {
      (result: Result<DesignatedRide?, NetworkingError>) in

      switch result {
      case .success(let designatedRide):
        completion(.success(designatedRide))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func getDesignatedRideDetailForDriver(
    driverId: Int,
    completion: @escaping (Result<DesignatedRide?, NetworkingError>) -> Void
  ) {
    provider.request(MobilityEndpoint.getDesignatedRideDetailForDriver(driverId: driverId)) {
      (result: Result<DesignatedRide?, NetworkingError>) in

      switch result {
      case .success(let designatedRide):
        completion(.success(designatedRide))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func updateUserLocation(
    location: Geotag,
    completion: @escaping (Result<EmptyResult, NetworkingError>) -> Void
  ) {
    provider.request(MobilityEndpoint.updateUserLocation(location: location)) {
      (result: Result<EmptyResult, NetworkingError>) in

      switch result {
      case .success:
        completion(.success(EmptyResult()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func getLatestUserLocation(
    userId: Int,
    completion: @escaping (Result<Geotag, NetworkingError>) -> Void
  ) {
    provider.request(MobilityEndpoint.getLatestUserLocation(userId: userId)) {
      (result: Result<Geotag, NetworkingError>) in

      switch result {
      case .success(let location):
        completion(.success(location))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

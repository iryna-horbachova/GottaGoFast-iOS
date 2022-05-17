//
//  DriverMainViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 14.05.2022.
//

import Foundation

class DriverMainViewModel {
  weak var viewController: DriverMainViewController!
  
  private let mobilityService = MobilityService()
  private let authenticationService = AuthenticationService()
  private var timer = Timer()
  
  private var driverId: Int?
  private var rideRequestId: Int?
  private var designatedRide: DesignatedRide? {
    didSet {
      DispatchQueue.main.async {
        self.viewController.updateUIForDesignatedRide()
      }
    }
  }

  private var userLocation: Geotag? {
    didSet {
      if let userLocation = userLocation {
        DispatchQueue.main.async {
          self.viewController.updateUserLocation(userLocation)
        }
      }
    }
  }
  
  init(viewController: DriverMainViewController) {
    self.viewController = viewController
    do {
      try driverId = Int(SecureStorageManager.shared.getData(type: .userId))
    } catch {
      driverId = nil
    }
  }
  
  func sendDriverLocation(latitude: Double, longitude: Double) {
    let geotag = Geotag(userId: nil, latitude: latitude, longitude: longitude, timestamp: nil)
    
    mobilityService.updateUserLocation(location: geotag) { result in
      switch result {
      case .success(_):
        NSLog("Successfully updated driver location")
      case .failure(let error):
        NSLog("Location update failed with error \(error.localizedDescription)")
      }
    }
  }
  
  func createRideRequest(_ rideRequest: RideRequest) {
    mobilityService.createRideRequest(rideRequest) { result in
      switch result {
      case .success(let ride):
        self.rideRequestId = ride.id
        self.scheduleTimer() { _ in
          self.checkForDesignatedRide()
        }
        NSLog("Successfully created ride request")
      case .failure(let error):
        NSLog("Ride request creation failed with error \(error.localizedDescription)")
      }
    }
  }
  
  func scheduleTimer(for method: @escaping (Timer) -> ()) {
    timer = Timer.scheduledTimer(
      withTimeInterval: 7,
      repeats: true,
      block: method
    )
  }
        
  func checkForDesignatedRide() {
    guard let driverId = driverId else {
      return
    }

    mobilityService.getDesignatedRideDetailForDriver(
      driverId: driverId
    ) { result in
      switch result {
      case .success(let ride):
        if let ride = ride {
          self.designatedRide = ride
          self.timer.invalidate()
        }
        NSLog("Received designated ride!")
      case .failure(let error):
        NSLog("Getting designated ride failed with error: \(error.localizedDescription)")
      }
    }
  }
  
  func updateDriverStatus(status: String) {
    guard let driverId = driverId else {
      return
    }
  
    authenticationService.updateDriverStatus(id: driverId, status: status) { result in
      switch result {
      case .success(_):
        NSLog("Updated driver status!")
      case .failure(let error):
        NSLog("Updating driver status failed with error: \(error.localizedDescription)")
      }
    }
  }
  
  func updateDesignatedRideStatus(status: String) {
    
    guard let designatedRide = designatedRide else {
      return
    }
    
    mobilityService.updateDesignatedRideStatus(id: designatedRide.id, status: status) { result in
      switch result {
      case .success(_):
        NSLog("Updated designated ride status!")
      case .failure(let error):
        NSLog("Updating designated ride status failed with error: \(error.localizedDescription)")
      }
    }
  }
  
}

//
//  DriverMainViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 14.05.2022.
//

import Foundation

enum DriverMainControllerState {
  case inActive
  case searchingForRideRequest
  case driveToDesignatedRideStartPoint
  case driveToDesignatedRideEndPoint
}

class DriverMainViewModel {
  private var viewController: DriverMainViewController!
  var modalViewController: DriverModalViewController!
  var controllerState = DriverMainControllerState.inActive {
    didSet {
      modalViewController.setupContentViewForDriverState()
    }
  }
  
  private let mobilityService = MobilityService()
  private let authenticationService = AuthenticationService()
  private var timer = Timer()
  
  private var driverId: Int?
  private var rideRequestId: Int?
  private var designatedRide: DesignatedRide? {
    didSet {
      DispatchQueue.main.async {
        if self.designatedRide != nil {
          self.controllerState = .driveToDesignatedRideStartPoint
        }
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
  
  func searchDesignatedRide() {
    NSLog("Begin searching for designated ride")
    scheduleTimer() { _ in
      self.checkForDesignatedRide()
    }
  }
  
  private func scheduleTimer(for method: @escaping (Timer) -> ()) {
    timer = Timer.scheduledTimer(
      withTimeInterval: 7,
      repeats: true,
      block: method
    )
  }
        
  func checkForDesignatedRide() {
    NSLog("Checking for designated ride")
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
    if status == "A" {
      controllerState = .searchingForRideRequest
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

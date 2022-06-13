//
//  DriverMainViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 14.05.2022.
//

import Foundation
import CoreLocation
import MapKit

enum DriverMainControllerState {
  case inActive
  case searchingForRideRequest
  case driveToDesignatedRideStartPoint
  case driveToDesignatedRideEndPoint
}

class DriverMainViewModel {
  // UI
  private var viewController: DriverMainViewController!
  var modalViewController: DriverModalViewController!
  var controllerState = DriverMainControllerState.inActive {
    didSet {
      switch controllerState {
      case .inActive:
        NSLog("Driver is currently not performing any job")
        finishDesignatedRide()
        DispatchQueue.main.async {
          self.viewController.finishRide()
        }
      case .searchingForRideRequest:
        NSLog("Searching for ride request")
        updateDriverStatus(status: "A")
        searchDesignatedRide()
      case .driveToDesignatedRideStartPoint:
        NSLog("Driving to the start point")
        DispatchQueue.main.async {
          self.viewController.updateUIForDesignatedRide()
        }
        
      case .driveToDesignatedRideEndPoint:
        updateDesignatedRideStatus(status: "I")
        DispatchQueue.main.async {
          self.viewController.updateUIForDesignatedRide()
        }
        NSLog("Driving to the end point")
      }
      DispatchQueue.main.async {
        self.modalViewController.setupContentViewForDriverState()
      }
     
    }
  }
  
  // Networking
  private let mobilityService = MobilityService()
  private let authenticationService = AuthenticationService()
  private var timer = Timer()
  
  // Data
  private var driverId: Int?

  private(set) var currentDesignatedRide: DesignatedRide? {
    didSet {
      if currentDesignatedRide != nil {
        getRideRequest()
      } else {
        controllerState = .inActive
      }
    }
  }
  
  private(set) var currentRideRequest: RideRequest? {
    didSet {
      getClientInfo()
    }
  }
  
  private(set) var currentClient: Client? {
    didSet {
      self.controllerState = .driveToDesignatedRideStartPoint
      DispatchQueue.main.async {
        //self.modalViewController.setupContentViewForDriverState()
      }
      
    }
  }
  
  // Current location of the client
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
  
  // Update server with current location of the driver
  func sendDriverLocation(latitude: Double, longitude: Double) {
    let geotag = Geotag(_id: nil, userId: nil, latitude: latitude, longitude: longitude, timestamp: nil)
    
    mobilityService.updateUserLocation(location: geotag) { result in
      switch result {
      case .success(_):
        NSLog("Successfully updated driver location")
      case .failure(let error):
        NSLog("Location update failed with error \(error.localizedDescription)")
      }
    }
  }
  
  private func searchDesignatedRide() {
    NSLog("Begin searching for designated ride")
    scheduleTimer() { _ in
      self.checkForDesignatedRide()
    }
  }
  
  private func scheduleTimer(for method: @escaping (Timer) -> ()) {
    timer = Timer.scheduledTimer(
      withTimeInterval: 10,
      repeats: true,
      block: method
    )
  }
        
  private func checkForDesignatedRide() {
    NSLog("Checking for designated ride")
    guard let driverId = driverId else {
      return
    }

    mobilityService.getDesignatedRideDetailForDriver(
      driverId: driverId
    ) { result in
      switch result {
      case .success(let ride):
        self.currentDesignatedRide = ride
        self.timer.invalidate()
        NSLog("Received designated ride!")
      case .failure(let error):
        NSLog("Getting designated ride failed with error: \(error.localizedDescription)")
      }
    }
  }
  
  private func getRideRequest() {
    guard let designatedRide = currentDesignatedRide else {
      return
    }
    mobilityService.getRideRequest(
      id: designatedRide.rideRequestId
    ) { result in
        switch result {
        case .success(let rideRequest):
          self.currentRideRequest = rideRequest
          NSLog("Received ride request info!")
        case .failure(let error):
          NSLog("Getting ride request failed with error: \(error.localizedDescription)")
        }
    }
  }
  
  private func getClientInfo() {
    guard let currentRideRequest = currentRideRequest else {
      return
    }
    authenticationService.getClientProfile(
      id: String(currentRideRequest.clientId)
    ) { result in
      switch result {
      case .success(let client):
        self.currentClient = client
        NSLog("Received client info!")
      case .failure(let error):
        NSLog("Getting client info failed with error: \(error.localizedDescription)")
      }
    }
  }
  
  private func updateDriverStatus(status: String) {
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
    
    guard let designatedRide = currentDesignatedRide else {
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
  
  func finishDesignatedRide() {
    currentRideRequest = nil
    currentDesignatedRide = nil
    currentClient = nil
    controllerState = .inActive
    updateDriverStatus(status: "I")
  }
}

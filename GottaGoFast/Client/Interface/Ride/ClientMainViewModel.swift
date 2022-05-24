//
//  ClientMainViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 13.05.2022.
//

import Foundation
import MapKit

enum ClientMainControllerState {
  case makingRideRequest
  case processingRideRequest
  case waitingForDriver
  case rideInProgress
}

class ClientMainViewModel {
  // UI
  private var viewController: ClientMainViewController!
  var modalViewController: ClientModalViewController! {
    didSet {
      if let region = region, let modalViewController = modalViewController {
        modalViewController.completer.region = region
      }
    }
  }
  var controllerState = ClientMainControllerState.makingRideRequest {
    didSet {
      DispatchQueue.main.async {
        self.modalViewController.setupContentViewForClientState()
      }
    }
  }
  var region: MKCoordinateRegion?

  // Networking
  private let mobilityService = MobilityService()
  private var timer = Timer()
  
  // Data
  private var rideRequestId: Int?
  private var designatedRide: DesignatedRide? {
    didSet {
      DispatchQueue.main.async {
        self.viewController.updateUIForDesignatedRide()
      }
    }
  }

  private var driverLocation: Geotag? {
    didSet {
      if let driverLocation = driverLocation {
        DispatchQueue.main.async {
          self.viewController.updateDriverLocation(driverLocation)
        }
      }
    }
  }
  
  init(viewController: ClientMainViewController) {
    self.viewController = viewController
  }
  
  func sendUserLocation(latitude: Double, longitude: Double) {
    let geotag = Geotag(userId: nil, latitude: latitude, longitude: longitude, timestamp: nil)
    
    mobilityService.updateUserLocation(location: geotag) { result in
      switch result {
      case .success(_):
        NSLog("Successfully updated user location")
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
    guard let rideRequestId = rideRequestId else {
      return
    }

    mobilityService.getDesignatedRideDetailForClient(
      rideRequestId: rideRequestId
    ) { result in
      switch result {
      case .success(let ride):
        if let ride = ride {
          self.designatedRide = ride
          self.timer.invalidate()
          self.scheduleTimer() { _ in
            self.getDriverLocation()
          }
        }
        NSLog("Received designated ride!")
      case .failure(let error):
        NSLog("Getting designated ride failed with error: \(error.localizedDescription)")
      }
    }
  }
  
  func getDriverLocation() {
    guard let designatedRide = designatedRide else {
      return
    }
    
    mobilityService.getLatestUserLocation(userId: designatedRide.driverId) { result in
      switch result {
      case .success(let geotag):
        self.driverLocation = geotag
        NSLog("Successfully retrieved driver's location")
      case .failure(let error):
        NSLog("Getting driver's location failed with error \(error.localizedDescription)")
      }
    }
  }
  
}

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
  case rideFinished
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
        self.modalViewController?.setupContentViewForClientState()
      }
    }
  }
  var region: MKCoordinateRegion?

  // Networking
  private let mobilityService = MobilityService()
  private let authenticationService = AuthenticationService()

  private var timer = Timer()
  
  // Data
  private var rideRequestId: Int?
  var designatedRide: DesignatedRide? {
    didSet {
      guard let designatedRide = designatedRide else {
        return
      }

      if designatedRide.status == "A" {
        getDriverInfo()
        getDriverLocation()
      } else {
        //timer.invalidate()
        designatedRideStatusUpdated()
      }
    }
  }
  
  var driver: Driver? {
    didSet {
      if driver != nil {
        controllerState = .waitingForDriver
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
    let geotag = Geotag(_id: nil, userId: nil, latitude: latitude, longitude: longitude, timestamp: nil)
    
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
    // Build on map
    viewController.updateUIForRideRequest(
      startLocationLatitude: rideRequest.startLocationLatitude,
      startLocationLongitude: rideRequest.startLocationLongitude,
      endLocationLatitude: rideRequest.endLocationLatitude,
      endLocationLongitude: rideRequest.endLocationLongitude
    )

    mobilityService.createRideRequest(rideRequest) { result in
      switch result {
      case .success(let ride):
        self.rideRequestId = ride.id

        NSLog("Successfully created ride request")
      case .failure(let error):
        NSLog("Ride request creation failed with error \(error.localizedDescription)")
      }
    }
    scheduleTimer() { _ in
      NSLog("Scheduling timer")
      self.checkForDesignatedRide()
      self.getDriverLocation()
    }
  }
  
  func scheduleTimer(for method: @escaping (Timer) -> ()) {
    NSLog("Schedule timer")
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

    NSLog("Check for designated ride")
    mobilityService.getDesignatedRideDetailForClient(
      rideRequestId: rideRequestId
    ) { result in
      switch result {
      case .success(let ride):
        if let ride = ride {
          if self.designatedRide == nil || self.designatedRide != ride{
            self.designatedRide = ride
          }
         // self.scheduleTimer() { _ in
         //   self.getDriverLocation()
         // }
        }
        NSLog("Received designated ride!")
      case .failure(let error):
        NSLog("Getting designated ride failed with error: \(error.localizedDescription)")
      }
    }
  }
  
  func designatedRideStatusUpdated() {
    guard let designatedRide = designatedRide else {
      return
    }
    
    switch designatedRide.status {
    case "I":
      controllerState = .rideInProgress
      DispatchQueue.main.async {
        self.viewController.updateUIForDesignatedRideStatus(designatedRide.status)
      }
      
      NSLog("Update UI for inprogress ride")
    case "F":
      controllerState = .rideFinished
      NSLog("Update UI for finished ride")
    case "C":
      controllerState = .makingRideRequest
      NSLog("Update UI for cancelled ride")
    default:
      NSLog("Status did not change")
    }
  }
  
  func cancelRideRequest() {
    guard let rideRequestId = rideRequestId else {
      return
    }
    mobilityService.cancelRideRequest(rideRequestId: rideRequestId) { result in
      switch result {
      case .success(_):
        self.controllerState = .makingRideRequest
        NSLog("Successfully cancelled ride request")
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
        NSLog("GEOTAG ***********")
        NSLog("\(self.driverLocation)")
        NSLog("\(geotag)")
        NSLog("Successfully retrieved driver's location")
      case .failure(let error):
        NSLog("Getting driver's location failed with error \(error.localizedDescription)")
      }
    }
  }
  
  func getDriverInfo() {
    guard let designatedRide = designatedRide else {
      return
    }
    
    authenticationService.getDriverProfile(id: "\(designatedRide.driverId)") { result in
      switch result {
      case .success(let driver):
        self.driver = driver
        NSLog("Successfully retrieved driver's location")
      case .failure(let error):
        NSLog("Getting driver's location failed with error \(error.localizedDescription)")
      }
    }
  }
  
}

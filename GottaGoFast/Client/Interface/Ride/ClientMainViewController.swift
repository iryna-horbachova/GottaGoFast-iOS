//
//  ClientMainViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import UIKit
import MapKit
import CoreLocation

class ClientMainViewController: UIViewController,
                                MKMapViewDelegate,
                                CLLocationManagerDelegate  {

  @IBOutlet weak var mapView: MKMapView!
  var locationManager: CLLocationManager!
  var viewModel: ClientMainViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = ClientMainViewModel(viewController: self)
    title = "title.ride".localized
    navigationController?.navigationBar.prefersLargeTitles = true
    determineCurrentLocation()
  }
  
  // MARK: - Location
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    let userLocation = locations[0] as CLLocation
    
    let center = CLLocationCoordinate2D(
                                        latitude: userLocation.coordinate.latitude,
                                        longitude: userLocation.coordinate.longitude
                                        )
    let mRegion = MKCoordinateRegion(
                                     center: center,
                                     span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                                    )
    
    mapView.setRegion(mRegion, animated: true)
    addAnnotation(location: userLocation)

    viewModel.sendUserLocation(
                               latitude: userLocation.coordinate.latitude,
                               longitude: userLocation.coordinate.longitude
                              )
  }

  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    NSLog("Error - locationManager: \(error.localizedDescription)")
  }
  
  func addAnnotation(location: CLLocation) {
    let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
    mkAnnotation.coordinate = CLLocationCoordinate2DMake(
                                                         location.coordinate.latitude,
                                                         location.coordinate.longitude
                                                        )
    mkAnnotation.title = "You"
    mapView.addAnnotation(mkAnnotation)
  }
  
  func determineCurrentLocation() {
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
    }
  }
  
  // MARK: - Update UI
  
  func updateUIForDesignatedRide() {
    
  }
  
  func updateUIForWaiting() {
    
  }

  func updateDriverLocation(_ driverLocation: Geotag) {
    
  }
}

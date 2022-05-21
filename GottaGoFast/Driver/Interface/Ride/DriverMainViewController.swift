//
//  DriverMainViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import UIKit
import MapKit
import CoreLocation

class DriverMainViewController: UIViewController,
                                MKMapViewDelegate,
                                CLLocationManagerDelegate {

  private var viewModel: DriverMainViewModel!

  @IBOutlet weak var mapView: MKMapView!
  var locationManager: CLLocationManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "title.ride".localized
    navigationController?.navigationBar.prefersLargeTitles = true
    mapView.delegate = self
    
    viewModel = DriverMainViewModel(viewController: self)
    determineCurrentLocation()
  }

  // MARK: - Managing Location and Maps

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    let userLocation = locations[0] as CLLocation
    let latitude = userLocation.coordinate.latitude
    let longitude = userLocation.coordinate.longitude
    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    mapView.setRegion(mRegion, animated: true)
    addAnnotation(location: userLocation)
    viewModel.sendDriverLocation(latitude: latitude, longitude: longitude)
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
  
  func mapView(
    _ mapView: MKMapView,
    viewFor annotation: MKAnnotation
  ) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { return nil }
    
    let identifier = "Annotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView!.canShowCallout = true
      annotationView!.image = UIImage(named: "car")
    } else {
      annotationView!.image = UIImage(named: "car")
    }

    return annotationView
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

  // MARK: - UI updates

  func updateUserLocation(_ userLocation: Geotag) {
    
  }
  
  func updateUIForDesignatedRide() {
    
  }

  @IBAction func tappedShowInfoButton(_ sender: UIButton) {
    presentModalController()
  }
  
  func presentModalController() {
    let modal = DriverModalViewController()
    modal.viewModel = viewModel
    modal.modalPresentationStyle = .overCurrentContext
    present(modal, animated: false)
  }
}

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
  
  private var locationManager: CLLocationManager!
  private var viewModel: ClientMainViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "title.ride".localized
    navigationController?.navigationBar.prefersLargeTitles = true
    mapView.delegate = self
    
    viewModel = ClientMainViewModel(viewController: self)
    determineCurrentLocation()
  }

  // MARK: - Managing Location and Maps

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
                                     span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    )
    viewModel.region = mRegion
    
    mapView.setRegion(mRegion, animated: true)

    for annotation in mapView.annotations {
      if let title = annotation.title, title == "You" {
        mapView.removeAnnotation(annotation)
      }
    }

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
    }

    if let location = locationManager.location,
       annotation.coordinate.latitude == location.coordinate.latitude &&
       annotation.coordinate.longitude == location.coordinate.longitude {
      annotationView!.image = UIImage(named: "client")
    } else if annotation.title == "Driver" {
      annotationView!.image = UIImage(named: "car")
    } else {
      annotationView!.image = UIImage(named: "map-pin")
    }

    return annotationView
  }

  func mapView(
    _ mapView: MKMapView,
    rendererFor overlay: MKOverlay
  ) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
    renderer.lineWidth = 5.0
    return renderer
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

  func updateDriverLocation(_ driverLocation: Geotag) {
    
  }
  
  func presentModalController() {
    let modal = ClientModalViewController()
    modal.viewModel = viewModel
    modal.modalPresentationStyle = .overCurrentContext
    present(modal, animated: false)
  }
  
  func finishRide() {
    mapView.removeOverlays(mapView.overlays)
  }

  @IBAction func tappedShowInfoButton(_ sender: UIButton) {
    presentModalController()
  }
  
}

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
  private var locationManager: CLLocationManager!

  @IBOutlet weak var mapView: MKMapView!

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
    let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    mapView.setRegion(mRegion, animated: true)
  
    for annotation in mapView.annotations {
      if let title = annotation.title, title == "You" {
        mapView.removeAnnotation(annotation)
      }
    }
    //userLocation.title
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
    }

    if let location = locationManager.location,
       annotation.coordinate.latitude == location.coordinate.latitude &&
       annotation.coordinate.longitude == location.coordinate.longitude {
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

  // MARK: - UI updates

  func updateUserLocation(_ userLocation: Geotag) {
    
  }
  
  func updateUIForDesignatedRide() {
    // Build and show route between start and end points
    guard let currentRideRequest = viewModel.currentRideRequest else {
      return
    }
    mapView.removeOverlays(mapView.overlays)
    var startCoordinate: CLLocationCoordinate2D
    var endCoordinate: CLLocationCoordinate2D
    if viewModel.controllerState == .driveToDesignatedRideStartPoint,
      let location = locationManager.location {
      startCoordinate = location.coordinate
      endCoordinate = CLLocationCoordinate2D(
        latitude: currentRideRequest.startLocationLatitude,
        longitude: currentRideRequest.startLocationLongitude
      )
    } else if viewModel.controllerState == .driveToDesignatedRideEndPoint {
      startCoordinate = CLLocationCoordinate2D(
        latitude: currentRideRequest.startLocationLatitude,
        longitude: currentRideRequest.startLocationLongitude
      )
      endCoordinate = CLLocationCoordinate2D(
        latitude: currentRideRequest.endLocationLatitude,
        longitude: currentRideRequest.endLocationLongitude
      )
    } else {
      return
    }
    let sourcePlacemark = MKPlacemark(coordinate: startCoordinate, addressDictionary: nil)
    let destinationPlacemark = MKPlacemark(coordinate: endCoordinate, addressDictionary: nil)
    
    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    
    let sourceAnnotation = MKPointAnnotation()
    sourceAnnotation.title = "You"
    
    if let location = sourcePlacemark.location {
      sourceAnnotation.coordinate = location.coordinate
    }
    
    let destinationAnnotation = MKPointAnnotation()
    
    if let location = destinationPlacemark.location {
      destinationAnnotation.coordinate = location.coordinate
    }
    
    mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
    
    let directionRequest = MKDirections.Request()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationMapItem
    directionRequest.transportType = .automobile
    
    // Calculate the direction
    let directions = MKDirections(request: directionRequest)
    directions.calculate { (response, error) -> Void in
      guard let response = response else {
        if let error = error {
          NSLog("Error: \(error)")
        }
        return
      }
      
      let builtRoute = response.routes[0]
      self.mapView.addOverlay((builtRoute.polyline), level: MKOverlayLevel.aboveRoads)
      let region = builtRoute.polyline.boundingMapRect
      self.mapView.setRegion(MKCoordinateRegion(region), animated: true)
    }
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
  
  func finishRide() {
    mapView.removeOverlays(mapView.overlays)
  }
}

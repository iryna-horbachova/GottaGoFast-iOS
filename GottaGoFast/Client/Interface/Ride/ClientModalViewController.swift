//
//  ClientModalViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 23.05.2022.
//

import UIKit
import CoreLocation
import MapKit

class ClientModalViewController: ModalViewController,
                                 UITextFieldDelegate {
  weak var viewModel: ClientMainViewModel! {
    didSet {
      viewModel.modalViewController = self
    }
  }
  let completer = MKLocalSearchCompleter()
  var startLocationCoordinate: CLLocationCoordinate2D?
  var endLocationCoordinate: CLLocationCoordinate2D?

  // UI States
  // Ride request details
  private lazy var startLocationTextField = makeTextField()
  private lazy var endLocationTextField = makeTextField()
  private lazy var locationSuggestionLabel = makeSecondaryLabel()
  private var editingTextField: UITextField?

  private lazy var adultsSeatsLabel = makeSecondaryLabel()
  private lazy var childrenSeatsLabel = makeSecondaryLabel()
  private lazy var animalSeatsLabel = makeSecondaryLabel()
  private lazy var trunkCapacityLabel = makeSecondaryLabel()

  private lazy var vehicleTypeSegmentedControl: UISegmentedControl = {
    let sControl = UISegmentedControl()
    sControl.frame = CGRect(x: 10, y: 150, width: 600, height: 50)
    sControl.selectedSegmentIndex = 0

    sControl.insertSegment(withTitle: "Passenger", at: 0, animated: true)
    sControl.insertSegment(withTitle: "Truck", at: 1, animated: true)
    sControl.insertSegment(withTitle: "Minivan", at: 2, animated: true)
  
    sControl.translatesAutoresizingMaskIntoConstraints = false
    return sControl
  }()
  
  private lazy var airConditionerPresentSegmentedControl: UISegmentedControl = {
    let sControl = UISegmentedControl()
    sControl.frame = CGRect(x: 10, y: 150, width: 500, height: 50)
    sControl.selectedSegmentIndex = 0

     sControl.insertSegment(withTitle: "Yes", at: 0, animated: true)
    sControl.insertSegment(withTitle: "No", at: 1, animated: true)

    sControl.translatesAutoresizingMaskIntoConstraints = false
    return sControl
  }()

  private lazy var locationSuggestionView: UIStackView = {
    let title = makeSecondaryLabel()
    title.text = "Did you mean"
    
    let stackView = UIStackView(arrangedSubviews: [title, locationSuggestionLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8.0
    return stackView
  }()
  
  private lazy var adultsSeatsView: UIStackView = {
    let stepper = makeStepper()
    stepper.addTarget(self, action: #selector(adultsSeatsStepperValueChanged(_:)), for: .valueChanged)
    let stackView = UIStackView(arrangedSubviews: [adultsSeatsLabel, stepper])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 5.0
    return stackView
  }()
  
  private lazy var childrenSeatsView: UIStackView = {
    let stepper = makeStepper()
    stepper.addTarget(self, action: #selector(childrenSeatsStepperValueChanged(_:)), for: .valueChanged)
    let stackView = UIStackView(arrangedSubviews: [childrenSeatsLabel, stepper])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 5.0
    return stackView
  }()
  
  private lazy var animalSeatsView: UIStackView = {
    let stepper = makeStepper()
    stepper.addTarget(self, action: #selector(animalSeatsStepperValueChanged(_:)), for: .valueChanged)
    let stackView = UIStackView(arrangedSubviews: [animalSeatsLabel, stepper])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 5.0
    return stackView
  }()
  
  private lazy var trunkCapacityView: UIStackView = {
    let stepper = makeStepper()
    stepper.addTarget(self, action: #selector(trunkCapacityStepperValueChanged(_:)), for: .valueChanged)
    let stackView = UIStackView(arrangedSubviews: [trunkCapacityLabel, stepper])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 5.0
    return stackView
  }()
  
  private lazy var airConditionerView: UIStackView = {
    let title = makeSecondaryLabel()
    title.text = "Air coditioner:"

    let stackView = UIStackView(arrangedSubviews: [title, airConditionerPresentSegmentedControl])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 5.0
    return stackView
  }()

  lazy var makingRideRequestStackView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "Make ride request"

    let button = makeActionButton()
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.setTitle("Continue", for: .normal)
    button.addTarget(self, action: #selector(tappedMakeRideRequestButton), for: .touchUpInside)
    
    let adultSeatsTitle = makeSecondaryLabel()
    adultSeatsTitle.text = "Adults:"
    
    let childrenSeatsTitle = makeSecondaryLabel()
    childrenSeatsTitle.text = "Children:"
    
    let animalSeatsTitle = makeSecondaryLabel()
    animalSeatsTitle.text = "Animals:"
    
    let trunkCapacityTitle = makeSecondaryLabel()
    trunkCapacityTitle.text = "Trunk capacity:"

    let spacer = UIView()

    let stackView = UIStackView(arrangedSubviews: [title, startLocationTextField, endLocationTextField,
                                                   locationSuggestionView, vehicleTypeSegmentedControl,
                                                   adultSeatsTitle, adultsSeatsView,
                                                   childrenSeatsTitle, childrenSeatsView,
                                                   animalSeatsTitle, animalSeatsView,
                                                   trunkCapacityTitle, trunkCapacityView,
                                                   airConditionerView,
                                                   button, spacer])
    locationSuggestionView.isHidden = true
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 10.0
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
  
    return stackView
  }()
  
  lazy var processingRideRequestStackView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "Processing your ride request"
    
    var activityView = UIActivityIndicatorView(style: .large)
    activityView.center = containerView.center
    activityView.startAnimating()
    
    let button = makeActionButton()
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.setTitle("Cancel", for: .normal)
    button.addTarget(self, action: #selector(tappedCancelRideRequestButton), for: .touchUpInside)
    
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, activityView, button, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()
  
  lazy var waitingForDriverView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "Waiting for driver"
    
    let driverNameLabel = makeSecondaryLabel()
    driverNameLabel.text = "Name: \(viewModel.driver!.user.firstName) \(viewModel.driver!.user.lastName)"
    let driverCarLabel = makeSecondaryLabel()
    driverCarLabel.text = "Vehicle: \(viewModel.driver!.vehicle.model)"
    let driverPhoneLabel = makeSecondaryLabel()
    driverPhoneLabel.text = "Phone: \(viewModel.driver!.user.phoneNumber)"
    let priceLabel = makeSecondaryLabel()
    priceLabel.text = "Price: \(viewModel.designatedRide!.price) $"
    
  /* let button = makeActionButton()
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.setTitle("Cancel", for: .normal)
    button.addTarget(self, action: #selector(tappedCancelRideRequestButton), for: .touchUpInside)*/
    
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, driverNameLabel, driverCarLabel, driverPhoneLabel, priceLabel, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()
  
  lazy var rideInProgressView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "Have a lovely ride!"
    
    let driverNameLabel = makeSecondaryLabel()
    driverNameLabel.text = "Name: \(viewModel.driver!.user.firstName) \(viewModel.driver!.user.lastName)"
    let driverCarLabel = makeSecondaryLabel()
    driverCarLabel.text = "Vehicle: \(viewModel.driver!.vehicle.model)"
    let driverPhoneLabel = makeSecondaryLabel()
    driverPhoneLabel.text = "Phone: \(viewModel.driver!.user.phoneNumber)"
    let priceLabel = makeSecondaryLabel()
    priceLabel.text = "Price: \(viewModel.designatedRide!.price) $"
    
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, driverNameLabel, driverCarLabel, driverPhoneLabel, priceLabel, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()
  
  lazy var rideFinishedView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "And here we go!"
    
    let hopeLabel = makeSecondaryLabel()
    hopeLabel.text = "We hope you enjoyed using our services!"
    let payLabel = makeSecondaryLabel()
    payLabel.text = "Please pay your driver: \(viewModel.designatedRide!.price)$"
    
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, hopeLabel, payLabel, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()

  // MARK: - Lifecycle methods

  override func viewDidLoad() {
    if viewModel.controllerState == .makingRideRequest {
      defaultHeight = 750
      currentContainerHeight = 750
    }
    super.viewDidLoad()

    completer.delegate = self
    configureTextFields()
    configureSeatsLabels()
    configureGestures()
    setupContentViewForClientState()
  }

  // MARK: - UI Configuration methods

  private func configureTextFields() {
    startLocationTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
    endLocationTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
    
    startLocationTextField.placeholder = "Start location"
    endLocationTextField.placeholder = "End location"
    
    startLocationTextField.delegate = self
    endLocationTextField.delegate = self
    
    startLocationTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged
    )
    endLocationTextField.addTarget(
      self,
      action: #selector(textFieldDidChange(_:)),
      for: .editingChanged
    )
  }
  
  private func configureSeatsLabels() {
    adultsSeatsLabel.text = "\(1)"
    childrenSeatsLabel.text = "\(0)"
    animalSeatsLabel.text = "\(0)"
    trunkCapacityLabel.text = "\(0)"
  }
  
  private func configureGestures() {
    locationSuggestionView.addGestureRecognizer(
      UITapGestureRecognizer(
        target: self,
        action: #selector(suggestionTapped(_:))
      )
    )
  }

  func setupContentViewForClientState() {
    clearContainerView()
    var contentView: UIView!
    switch viewModel.controllerState {
    case .makingRideRequest:
      contentView = makingRideRequestStackView
    case .processingRideRequest:
      contentView = processingRideRequestStackView
    case .waitingForDriver:
      contentView = waitingForDriverView
    case .rideInProgress:
      contentView = rideInProgressView
    case .rideFinished:
      contentView = rideFinishedView
    default:
      NSLog("Setting up content view in modal controller")
    }

    setupContentView(contentView)
  }
  
  @objc func tappedMakeRideRequestButton() {
    guard let startLocationText = startLocationTextField.text,
          let endLocationText = endLocationTextField.text,
          let region = viewModel.region else {
      present(
        UIAlertController.alertWithOKAction(
          title: "Error!",
          message: "Invalid locations!"),
        animated: true
      )
      return
    }
    
    let group = DispatchGroup()
    group.enter()
    searchPlace(naturalLanguageQuery: startLocationText, region: region) { coordinate in
      if let coordinate = coordinate {
        self.startLocationCoordinate = coordinate
      }
      group.leave()
    }
    
    group.enter()
    searchPlace(naturalLanguageQuery: endLocationText, region: region) { coordinate in
      if let coordinate = coordinate {
        self.endLocationCoordinate = coordinate
      }
      group.leave()
    }

    group.notify(queue: .main) {
      guard let startLocationCoordinate = self.startLocationCoordinate,
      let endLocationCoordinate = self.endLocationCoordinate  else {
        DispatchQueue.main.async {
          self.present(
            UIAlertController.alertWithOKAction(
              title: "Error!",
              message: "Invalid values were provided for locations!"),
            animated: true
          )
        }
        return
      }

      var clientId: Int
      do {
        try clientId = Int(SecureStorageManager.shared.getData(type: .userId))!
      } catch {
        clientId = 1
      }
      
      let vehicleTypeIndex = self.vehicleTypeSegmentedControl.selectedSegmentIndex
      let airConditionerPresentIndex = self.airConditionerPresentSegmentedControl.selectedSegmentIndex
      var vehicleType: String
      
      switch vehicleTypeIndex {
      case 0:
        vehicleType = "P"
      case 1:
        vehicleType = "T"
      default:
        vehicleType = "M"
      }
      
      let airConditionerPresent = airConditionerPresentIndex == 0 ? true : false
      let adultsSeatsNum = Int(self.adultsSeatsLabel.text!)!
      let childrenSeatsNum = Int(self.childrenSeatsLabel.text!)!
      let animalSeatsNum = Int(self.animalSeatsLabel.text!)!
      let trunkCapacityNum = Int(self.trunkCapacityLabel.text!)!
      
      let rideRequest = RideRequest(
        id: nil, clientId: clientId,
        startLocationLatitude: startLocationCoordinate.latitude, startLocationLongitude: startLocationCoordinate.longitude,
        endLocationLatitude: endLocationCoordinate.latitude, endLocationLongitude: endLocationCoordinate.longitude,
        adultsSeatsNumber: adultsSeatsNum, childrenSeatsNumber: childrenSeatsNum,
        animalSeatsNumber: animalSeatsNum, trunkCapacity: trunkCapacityNum, airConditionerPresent: airConditionerPresent
      )
      self.viewModel.createRideRequest(rideRequest)
      self.viewModel.controllerState = .processingRideRequest
      NSLog("Submitting Ride request")
    }
  }
  
  @objc func tappedCancelRideRequestButton() {
    viewModel.cancelRideRequest()
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    hideSuggestionView()

    if completer.isSearching {
      completer.cancel()
    }

    editingTextField = textField
  }

  @objc private func textFieldDidChange(_ field: UITextField) {
    guard let query = field.text else {
      hideSuggestionView()
      
      if completer.isSearching {
        completer.cancel()
      }
      return
    }
    
    completer.queryFragment = query
  }
  
  private func hideSuggestionView() {
    UIView.animate(withDuration: 1.0) {
      self.locationSuggestionView.isHidden = true
    }
  }
  
  private func showSuggestion(_ suggestion: String) {
    locationSuggestionLabel.text = suggestion

    UIView.animate(withDuration: 1.0) {
      self.locationSuggestionView.isHidden = false
    }
  }
  
  // UI targets
  
  @objc func adultsSeatsStepperValueChanged(_ sender: UIStepper) {
    adultsSeatsLabel.text = Int(sender.value).description
  }
  
  @objc func childrenSeatsStepperValueChanged(_ sender: UIStepper) {
    childrenSeatsLabel.text = Int(sender.value).description
  }
  
  @objc func animalSeatsStepperValueChanged(_ sender: UIStepper) {
    animalSeatsLabel.text = Int(sender.value).description
  }
  
  @objc func trunkCapacityStepperValueChanged(_ sender: UIStepper) {
    trunkCapacityLabel.text = Int(sender.value).description
  }

  @objc private func suggestionTapped(_ gesture: UITapGestureRecognizer) {
    hideSuggestionView()

    editingTextField?.text = locationSuggestionLabel.text
    editingTextField = nil
  }
}

extension ClientModalViewController: MKLocalSearchCompleterDelegate {

  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    guard let firstResult = completer.results.first else {
      return
    }
    
    showSuggestion(firstResult.title)
  }

  func completer(
    _ completer: MKLocalSearchCompleter,
    didFailWithError error: Error
  ) {
    NSLog("Error suggesting a location: \(error.localizedDescription)")
  }
  
  func searchPlace(naturalLanguageQuery: String, region: MKCoordinateRegion, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = naturalLanguageQuery
    request.region = region

    MKLocalSearch(request: request).start { response, _ in
 
      if let firstItem = response?.mapItems.first {
        completion(firstItem.placemark.location?.coordinate)
      } else {
        completion(nil)
      }
    }

  }
}

//
//  DriverModalViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 17.05.2022.
//

import UIKit

class DriverModalViewController: ModalViewController {
  
  weak var viewModel: DriverMainViewModel! {
    didSet {
      viewModel.modalViewController = self
    }
  }

  // MARK: - State views

  lazy var inActiveStateStackView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "You are currently inactive"
    let button = makeActionButton()
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.setTitle("Search for ride request", for: .normal)
    button.addTarget(self, action: #selector(tappedSearchFoRideRequestButton), for: .touchUpInside)
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, button, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()
  
  lazy var searchingForRideRequestStateStackView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "Searching for ride request"
    
    var activityView = UIActivityIndicatorView(style: .large)
    activityView.center = containerView.center
    activityView.startAnimating()
    
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, activityView, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()
  
  lazy var clientRideRequestInfoView: UIStackView = {
    let clientNameLabel = makeSecondaryLabel()
    clientNameLabel.text = "Client: \(viewModel.currentClient!.user.firstName) \(viewModel.currentClient!.user.lastName)"
    let seatsInfoLabel = makeSecondaryLabel()
    seatsInfoLabel.text = "\(viewModel.currentRideRequest!.adultsSeatsNumber) adults, \(viewModel.currentRideRequest!.childrenSeatsNumber) children, \(viewModel.currentRideRequest!.animalSeatsNumber) animals, \(viewModel.currentRideRequest!.trunkCapacity) trunk space."
    let priceLabel = makeSecondaryLabel()
    priceLabel.text = "Price: \(viewModel.currentDesignatedRide!.price) $"
    
    let stackView = UIStackView(arrangedSubviews: [clientNameLabel, seatsInfoLabel, priceLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
    
    return stackView
  }()
  
  lazy var designatedRideToStartPointStateStackView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "Drive to start point"
    
    let button = makeActionButton()
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.setTitle("Begin a ride", for: .normal)
    button.addTarget(self, action: #selector(tappedBeginRideButton), for: .touchUpInside)
    
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, clientRideRequestInfoView, button, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()
  
  lazy var designatedRideToEndPointStateStackView: UIStackView = {
    let title = makeTitleLabel()
    title.text = "Drive to end point"
    
    let button = makeActionButton()
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.setTitle("End a ride", for: .normal)
    button.addTarget(self, action: #selector(tappedEndRideButton), for: .touchUpInside)
    
    let spacer = UIView()
    let stackView = UIStackView(arrangedSubviews: [title, clientRideRequestInfoView, button, spacer])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 12.0
  
    return stackView
  }()
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupContentViewForDriverState()
  }

  // MARK: - UI Methods

  func setupContentViewForDriverState() {
    clearContainerView()
    var contentView: UIView!
    switch viewModel.controllerState {
    case .inActive:
      contentView = inActiveStateStackView
      NSLog("Setting up controller to search for ride")
    case .searchingForRideRequest:
      contentView = searchingForRideRequestStateStackView
    case .driveToDesignatedRideStartPoint:
      contentView = designatedRideToStartPointStateStackView
    case .driveToDesignatedRideEndPoint:
      contentView = designatedRideToEndPointStateStackView
    }

    setupContentView(contentView)
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  @objc func tappedSearchFoRideRequestButton() {
    viewModel.controllerState = .searchingForRideRequest
    setupContentViewForDriverState()
  }
  
  @objc func tappedBeginRideButton() {
    viewModel.controllerState = .driveToDesignatedRideEndPoint
    viewModel.updateDesignatedRideStatus(status: "I")
  }
  
  @objc func tappedEndRideButton() {
    viewModel.updateDesignatedRideStatus(status: "F")
    viewModel.controllerState = .inActive
  }
} 



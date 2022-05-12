//
//  DriverProfileViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import UIKit

class DriverProfileViewController: UIViewController {

  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var lastNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var phoneNumberLabel: UILabel!
  @IBOutlet weak var driverLicenseLabel: UILabel!
  @IBOutlet weak var taxiLicenseLabel: UILabel!
  @IBOutlet weak var vehicleModelLabel: UILabel!
  @IBOutlet weak var vehicleInsurancePolicyLabel: UILabel!
  @IBOutlet weak var vehicleTypeLabel: UILabel!
  @IBOutlet weak var vehicleAdultSeatsLabel: UILabel!
  @IBOutlet weak var vehicleChildrenSeatsLabel: UILabel!
  @IBOutlet weak var vehicleAnimalSeatsLabel: UILabel!
  @IBOutlet weak var vehicleTrunkCapacityLabel: UILabel!
  
  var viewModel: DriverProfileViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = DriverProfileViewModel(viewController: self)
    viewModel.fetchProfileDetails()
    
    title = "title.profile".localized
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func updateProfileDetails() {
    firstNameLabel.text = viewModel.driver?.user.firstName
    lastNameLabel.text = viewModel.driver?.user.lastName
    emailLabel.text = viewModel.driver?.user.email
    phoneNumberLabel.text = viewModel.driver?.user.phoneNumber
    driverLicenseLabel.text = viewModel.driver?.driverLicenseNumber
    taxiLicenseLabel.text = viewModel.driver?.taxiLicenseNumber
    vehicleModelLabel.text = viewModel.driver?.vehicle.model
    vehicleInsurancePolicyLabel.text = viewModel.driver?.vehicle.insurancePolicyNumber
    vehicleTypeLabel.text = viewModel.driver?.vehicle.type
    vehicleAdultSeatsLabel.text = String(viewModel.driver!.vehicle.adultsSeatsNumber)
    vehicleChildrenSeatsLabel.text = String(viewModel.driver!.vehicle.childrenSeatsNumber)
    vehicleAnimalSeatsLabel.text = String(viewModel.driver!.vehicle.animalSeatsNumber)
    vehicleTrunkCapacityLabel.text = String(viewModel.driver!.vehicle.trunkCapacity)
    
    /*
     Driver(user: GottaGoFastDriver.User(id: Optional(14), email: "driver@me.com", firstName: "Oleg", lastName: "Driver", gender: "U", phoneNumber: "214432"), vehicle: GottaGoFastDriver.Vehicle(id: Optional(8), model: "Tesla", type: "P", category: "N", insurancePolicyNumber: "329874329", adultsSeatsNumber: 4, childrenSeatsNumber: 0, animalSeatsNumber: 0, trunkCapacity: 0, airConditionerPresent: true), passportNumber: "34234234", driverLicenseNumber: "4235223", taxiLicenseNumber: "425223", status: "N")
     */
  }

}

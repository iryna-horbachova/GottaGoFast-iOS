//
//  SignUpDriverViewController.swift
//  GottaGoFastDriver
//
//  Created by Iryna Horbachova on 11.05.2022.
//

import UIKit

class SignUpDriverViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  
  @IBOutlet weak var passportTextField: UITextField!
  @IBOutlet weak var driverLicenseTextField: UITextField!
  
  @IBOutlet weak var taxiLicenseTextField: UITextField!
  @IBOutlet weak var vehicleModelTextField: UITextField!
  @IBOutlet weak var vehicleTypeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var vehicleInsurancePolicyTextField: UITextField!
  
  @IBOutlet weak var adultsSeatsLabel: UILabel!
  @IBOutlet weak var childrenSeatsLabel: UILabel!
  @IBOutlet weak var animalSeatsLabel: UILabel!
  @IBOutlet weak var trunkCapacityLabel: UILabel!
  
  @IBOutlet weak var adultsSeatsStepper: UIStepper!
  @IBOutlet weak var childrenSeatsStepper: UIStepper!
  @IBOutlet weak var animalSeatsStepper: UIStepper!
  @IBOutlet weak var trunkCapacityStepper: UIStepper!
  
  @IBOutlet weak var airConditionerPresentSegmentedControl: UISegmentedControl!
  
  var viewModel: SignUpDriverViewModel!
  var registrationCompleted = false {
    didSet {
      NSLog("REGISTRATION COMPLETED")
      viewModel.performSignIn(email: emailTextField.text!, password: passwordTextField.text!)
    }
  }
  
  var authenticationCompleted = false {
    didSet {
      DispatchQueue.main.async {
        NSLog("AUTHENTICATIOM COMPLETED")
        self.proceedToMainApplication()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = SignUpDriverViewModel(viewController: self)

    adultsSeatsStepper.minimumValue = 0
    adultsSeatsStepper.maximumValue = 50
    
    childrenSeatsStepper.minimumValue = 0
    childrenSeatsStepper.maximumValue = 50
    
    animalSeatsStepper.minimumValue = 0
    animalSeatsStepper.maximumValue = 50
    
    trunkCapacityStepper.minimumValue = 0
    trunkCapacityStepper.maximumValue = 50
  }
  
  @IBAction func adultsSeatsStepperValueChanged(_ sender: UIStepper) {
    adultsSeatsLabel.text = Int(sender.value).description
  }
  
  @IBAction func childrenSeatsStepperValueChanged(_ sender: UIStepper) {
    childrenSeatsLabel.text = Int(sender.value).description
  }
  
  @IBAction func animalSeatsValueChanged(_ sender: UIStepper) {
    animalSeatsLabel.text = Int(sender.value).description
  }
  
  @IBAction func trunkCapacityStepperValueChanged(_ sender: UIStepper) {
    trunkCapacityLabel.text = Int(sender.value).description
  }
  
  @IBAction func tappedSignUpButton(_ sender: UIButton) {
    guard let email = emailTextField.text, let firstName = firstNameTextField.text,
      let lastName = lastNameTextField.text, let phoneNumber = phoneNumberTextField.text,
      let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text,
      let passport = passportTextField.text, let driverLicense = driverLicenseTextField.text,
      let taxiLicense = taxiLicenseTextField.text, let vehicleModel = vehicleModelTextField.text,
      let vehicleInsurancePolicy = vehicleInsurancePolicyTextField.text else {
      return
    }
    let vehicleTypeIndex = vehicleTypeSegmentedControl.selectedSegmentIndex
    let airConditionerPresentIndex = airConditionerPresentSegmentedControl.selectedSegmentIndex
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
    let adultsSeatsNum = Int(adultsSeatsLabel.text!)!
    let childrenSeatsNum = Int(childrenSeatsLabel.text!)!
    let animalSeatsNum = Int(animalSeatsLabel.text!)!
    let trunkCapacityNum = Int(trunkCapacityLabel.text!)!
    
    let vehicle = Vehicle(
      id: nil, model: vehicleModel,type: vehicleType,
      category: "N", insurancePolicyNumber: vehicleInsurancePolicy,
      adultsSeatsNumber: adultsSeatsNum, childrenSeatsNumber: childrenSeatsNum,
      animalSeatsNumber: animalSeatsNum, trunkCapacity: trunkCapacityNum,
      airConditionerPresent: airConditionerPresent
    )
    
    let user = UserRegistration(
      email: email, firstName: firstName,
      lastName: lastName, gender: "U",
      phoneNumber: phoneNumber, birthDate: nil
    )
    let driverRegistration = DriverRegistration(
      user: user, vehicle: vehicle, password: password,
      confirmPassword: confirmPassword, passportNumber: passport,
      driverLicenseNumber: driverLicense, taxiLicenseNumber: taxiLicense
    )
    
    viewModel.performSignUp(driverRegistration: driverRegistration)
  }
  
  @IBAction func tappedSignInButton(_ sender: UIButton) {
    performTransition(to: SignInViewController(nibName: "SignInViewController", bundle: .main))
  }

  func proceedToMainApplication() {
    performTransition(to: DriverTabBarController())
  }

}

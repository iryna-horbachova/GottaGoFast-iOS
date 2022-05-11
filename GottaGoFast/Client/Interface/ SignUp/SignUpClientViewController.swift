//
//  SignUpClientViewController.swift
//  GottaGoFastClient
//
//  Created by Iryna Horbachova on 11.05.2022.
//

import UIKit

class SignUpClientViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  
  var viewModel: SignUpClientViewModel!
  
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

    viewModel = SignUpClientViewModel(viewController: self)
  }
  

  // TODO
  func proceedToMainApplication() {
    // Proceed to the tabbar
  }

  @IBAction func tappedSignUpButton(_ sender: UIButton) {
    guard let email = emailTextField.text, let firstName = firstNameTextField.text,
      let lastName = lastNameTextField.text, let phoneNumber = phoneNumberTextField.text,
      let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
      return
    }
    let user = UserRegistration(email: email, firstName: firstName, lastName: lastName, gender: "U", phoneNumber: phoneNumber, birthDate: nil)
    let clientRegistration = ClientRegistration(user: user, rideDiscount: nil, password: password, confirmPassword: confirmPassword)
    viewModel.performSignUp(clientRegistration: clientRegistration)
  }
  
}

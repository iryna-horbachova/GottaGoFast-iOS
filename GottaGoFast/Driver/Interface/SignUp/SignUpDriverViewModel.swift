//
//  SignUpDriverViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 11.05.2022.
//

import Foundation

class SignUpDriverViewModel {
  weak var viewController: SignUpDriverViewController!
  private let authenticationService = AuthenticationService()
  private let networkingService = NetworkingService(provider: NetworkingProvider())

  init(viewController: SignUpDriverViewController) {
    self.viewController = viewController
  }

  func inputIsValid(driverRegistration: DriverRegistration) -> Bool {
    return true //Validator.isValid(email: email) && password.count > 5
  }
  
  func performSignUp(driverRegistration: DriverRegistration) {
    // perform sign up
    authenticationService.registerDriver(driverRegistration) { [weak self] result in
      switch result {
      case .success(_):
        NSLog("SUCCESS")
        self?.viewController.registrationCompleted = true
      case .failure(let error):
        NSLog("Error \(error)")
      }
    }
  }

  func performSignIn(email: String, password: String) {
    
    authenticationService.performLogin(email: email, password: password) { [weak self] result in
      switch result {
      case .success(_):
        NSLog("SUCCESS")
        self?.viewController.authenticationCompleted = true
      case .failure(let error):
        NSLog("Error \(error)")
      }
    }
  }
}

//
//  SignUpViewController.swift
//  GottaGoFastDriver
//
//  Created by Iryna Horbachova on 11.05.2022.
//

import Foundation

class SignUpClientViewModel {
  weak var viewController: SignUpClientViewController!
  private let authenticationService = AuthenticationService()
  private let networkingService = NetworkingService(provider: NetworkingProvider())

  init(viewController: SignUpClientViewController) {
    self.viewController = viewController
  }

  func inputIsValid(clientRegistration: ClientRegistration) -> Bool {
    return true //Validator.isValid(email: email) && password.count > 5
  }
  
  func performSignUp(clientRegistration: ClientRegistration) {
    // perform sign up
    authenticationService.registerClient(clientRegistration) { [weak self] result in
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
        NSLog("Login successfully performed")
        self?.viewController.authenticationCompleted = true
      case .failure(let error):
        NSLog("Error \(error)")
      }
    }
  }
}

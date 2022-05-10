//
//  SignInViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

class SignInViewModel {

  weak var viewController: SignInViewController!
  private let authenticationService = AuthenticationService()
  private let networkingService = NetworkingService(provider: NetworkingProvider())

  init(viewController: SignInViewController) {
    self.viewController = viewController
  }

  func inputIsValid(email: String, password: String) -> Bool {
    return true //Validator.isValid(email: email) && password.count > 5
  }
  
  func performSignIn(email: String, password: String) {
    
    authenticationService.performLogin(email: email, password: password) { [weak self] result in
      switch result {
      case .success(_):
        NSLog("SUCCESS")
        self?.viewController.isSignedIn = true
      case .failure(let error):
        NSLog("Error \(error)")
      }
    }
  }

}

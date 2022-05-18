//
//  ClientProfileViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import Foundation


class ClientProfileViewModel {
  weak var viewController: ClientProfileViewController!
  var userId: String?
  var client: Client? {
    didSet {
      DispatchQueue.main.async {
        self.viewController.updateProfileDetails()
      }
    }
  }

  private let authenticationService = AuthenticationService()
  
  init(viewController: ClientProfileViewController) {
    self.viewController = viewController
  }
  
  func fetchProfileDetails() {
    do {
      userId = try SecureStorageManager.shared.getData(type: .userId)
    } catch {
      NSLog("Error: User id unavailable")
      return
    }
    authenticationService.getClientProfile(id: userId!) { [weak self] result in
      switch result {
      case .success(let client):
        NSLog("Successfully fetched client profile")
        self?.client = client
      case .failure(let error):
        NSLog("Error \(error)")
      }
    }
  }
  
  func logout() {
    do {
      try SecureStorageManager.shared.removeAllData()
    } catch {
      NSLog("Unable to logout user")
    }
  }
}

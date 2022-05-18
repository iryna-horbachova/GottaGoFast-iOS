//
//  DriverProfileViewModel.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import Foundation

class DriverProfileViewModel {
  weak var viewController: DriverProfileViewController!
  private var userId: String?
  var driver: Driver? {
    didSet {
      DispatchQueue.main.async {
        self.viewController.updateProfileDetails()
      }
    }
  }

  private let authenticationService = AuthenticationService()
  
  init(viewController: DriverProfileViewController) {
    self.viewController = viewController
  }
  
  func fetchProfileDetails() {
    do {
      userId = try SecureStorageManager.shared.getData(type: .userId)
    } catch {
      NSLog("Error: User id unavailable")
      return
    }
    authenticationService.getDriverProfile(id: userId!) { [weak self] result in
      switch result {
      case .success(let driver):
        NSLog("Successfully fetched driver profile")
        self?.driver = driver
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

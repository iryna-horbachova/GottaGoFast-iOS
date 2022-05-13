//
//  AuthenticationService.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

final class AuthenticationService: NetworkingService, AuthenticationServiceType {

  func performLogin(
    email: String, password: String,
    completion: @escaping (Result<EmptyResult, NetworkingError>) -> Void
  ) {
    provider.request(AuthenticationEndpoint.performLogin(email: email, password: password)) { (result: Result<Token, NetworkingError>) in
      
      switch result {
      case .success(let token):
        AuthenticationManager.shared.currentToken = token
        do {
          try SecureStorageManager.shared.updateData(token.refresh, type: .refreshToken)
          try SecureStorageManager.shared.updateData(token.access, type: .accessToken)
          try SecureStorageManager.shared.updateData(String(token.userId), type: .userId)
          AppModeManager.shared.setAppMode(mode: .authenticated)
        } catch {
          AppModeManager.shared.setAppMode(mode: .notAuthenticated)
          NSLog("Failed to store token")
        }
        completion(.success(EmptyResult()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func registerClient(
    _ clientRegistration: ClientRegistration,
    completion: @escaping (Result<Client, NetworkingError>) -> Void
  ) {
    provider.request(AuthenticationEndpoint.registerClient(clientRegistration)) { (result: Result<Client, NetworkingError>) in
      
      switch result {
      case .success(let client):
        completion(.success(client))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func registerDriver(
    _ driver: DriverRegistration,
    completion: @escaping (Result<Driver, NetworkingError>) -> Void
  ) {
    provider.request(AuthenticationEndpoint.registerDriver(driver)) { (result: Result<Driver, NetworkingError>) in
      
      switch result {
      case .success(let driver):
        completion(.success(driver))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getClientProfile(
    id: String,
    completion: @escaping (Result<Client, NetworkingError>) -> Void
  ) {
    provider.request(AuthenticationEndpoint.getClientProfile(id: id)) { (result: Result<Client, NetworkingError>) in
      
      switch result {
      case .success(let client):
        completion(.success(client))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getDriverProfile(
    id: String,
    completion: @escaping (Result<Driver, NetworkingError>) -> Void
  ) {
    provider.request(AuthenticationEndpoint.getDriverProfile(id: id)) { (result: Result<Driver, NetworkingError>) in
      
      switch result {
      case .success(let driver):
        completion(.success(driver))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

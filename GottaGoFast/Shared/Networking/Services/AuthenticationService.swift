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
        completion(.success(EmptyResult()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func refreshLogin(
    refreshToken: String,
    completion: @escaping (Result<EmptyResult, NetworkingError>) -> Void
  ) {
    provider.request(AuthenticationEndpoint.refreshLogin(refreshToken: refreshToken)) { (result: Result<Token, NetworkingError>) in
      
      switch result {
      case .success(let token):
        AuthenticationManager.shared.currentToken = token
        completion(.success(EmptyResult()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func registerClient(
    _ client: Client,
    completion: @escaping (Result<Client, NetworkingError>) -> Void
  ) {
    provider.request(AuthenticationEndpoint.registerClient(client)) { (result: Result<Client, NetworkingError>) in
      
      switch result {
      case .success(let client):
        completion(.success(client))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func registerDriver(
    _ driver: Driver,
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
}

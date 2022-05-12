//
//  AuthenticationServiceType.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

protocol AuthenticationServiceType {
  func performLogin(
    email: String, password: String,
    completion: @escaping (Result <EmptyResult, NetworkingError>) -> Void
  )

  func refreshLogin(
    refreshToken: String,
    completion: @escaping (Result <EmptyResult, NetworkingError>) -> Void
  )

  func registerClient(
    _ clientRegistraion: ClientRegistration,
    completion: @escaping (Result <Client, NetworkingError>) -> Void
  )

  func registerDriver(
    _ driver: DriverRegistration,
    completion: @escaping (Result <Driver, NetworkingError>) -> Void
  )
  
  func getClientProfile(
    id: String,
    completion: @escaping (Result <Client, NetworkingError>) -> Void
  )
  
  func getDriverProfile(
    id: String,
    completion: @escaping (Result <Driver, NetworkingError>) -> Void
  )
}

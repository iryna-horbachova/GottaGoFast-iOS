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
    _ client: Client,
    completion: @escaping (Result <Client, NetworkingError>) -> Void
  )

  func registerDriver(
    _ driver: Driver,
    completion: @escaping (Result <Driver, NetworkingError>) -> Void
  )
}

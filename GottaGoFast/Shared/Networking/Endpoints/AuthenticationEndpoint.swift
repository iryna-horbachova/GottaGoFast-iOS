//
//  AuthenticationEndpoint.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

enum AuthenticationEndpoint {
  case performLogin(email: String, password: String)
  case refreshLogin(refreshToken: String)
  case registerClient(_ client: Client)
  case registerDriver(_ driver: Driver)
}

extension AuthenticationEndpoint: EndpointType {
  var path: String {
    switch self {
    case .performLogin:
      return ":8000/api/profile/token/"
    case .refreshLogin:
      return ":8000/api/profile/refresh/"
    case .registerClient:
      return ":8000/api/profile/clients/register/"
    case .registerDriver:
      return ":8000/api/profile/drivers/register/"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .performLogin:
      return .post
    case .refreshLogin:
      return .post
    case .registerClient:
      return .post
    case .registerDriver:
      return .post
    }
  }

  var headers: [String : String]? {
    return nil
  }

  var needsAuthorization: Bool {
    return false
  }

  var body: Encodable? {
    switch self {
    case .performLogin(let email, let password):
      return ["username": email, "password": password]
    case .refreshLogin(let refreshToken):
      return ["refresh": refreshToken]
    case .registerClient(let client):
      return client
    case .registerDriver(let driver):
      return driver
    }
  }
}

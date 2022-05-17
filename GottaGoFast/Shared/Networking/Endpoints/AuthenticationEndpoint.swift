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
  case registerClient(_ clientRegistration: ClientRegistration)
  case registerDriver(_ driver: DriverRegistration)
  case getClientProfile(id: String)
  case getDriverProfile(id: String)
  case updateDriverStatus(driverId: Int, newStatus: String)
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
    case .getClientProfile(let id):
      return ":8000/api/profile/clients/\(id)/"
    case .getDriverProfile(let id):
      return ":8000/api/profile/drivers/\(id)/"
    case .updateDriverStatus(let driverId, _):
      return ":8000/api/profile/drivers/status/\(driverId)/"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .performLogin, .refreshLogin:
      return .post
    case .registerClient, .registerDriver:
      return .post
    case .getClientProfile, .getDriverProfile:
      return .get
    case .updateDriverStatus:
      return .put
    }
  }

  var headers: [String : String]? {
    return nil
  }

  var needsAuthorization: Bool {
    switch self {
    case .getClientProfile, .getDriverProfile:
      return true
    default:
      return false
    }
  }

  var body: Encodable? {
    switch self {
    case .performLogin(let email, let password):
      return ["email": email, "password": password]
    case .refreshLogin(let refreshToken):
      return ["refresh": refreshToken]
    case .registerClient(let client):
      return client
    case .registerDriver(let driver):
      return driver
    case .getClientProfile, .getDriverProfile:
      return nil
    case .updateDriverStatus(_, let newStatus):
      return ["status": newStatus]
    }
  }
}

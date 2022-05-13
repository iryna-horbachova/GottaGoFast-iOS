//
//  NetworkingError.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

enum NetworkingError: Error {
  case invalidData
  case invalidResponse
  case unableToComplete
  case encodingFailed
  case decodingFailed
  case authenticationFailed
}

extension NetworkingError: LocalizedError {
  
  var errorDescription: String? {
    switch self {
    case .invalidData:
      return "networking.error.invalid.data".localized
    case .invalidResponse:
      return "networking.error.invalid.response".localized
    case .unableToComplete:
      return "networking.error.completion.unabled".localized
    case .encodingFailed:
      return "networking.error.encoding.failed".localized
    case .decodingFailed:
      return "networking.error.decoding.failed".localized
    case .authenticationFailed:
      return "networking.error.authentication.failed".localized
    }
  }
}

//
//  DataEncoder.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

protocol DataEncoder {
  static func encode(_ parameters: Encodable) throws -> Data
}

final class JSONDataEncoder: DataEncoder {

  static func encode(_ parameters: Encodable) throws -> Data {
    
    guard let jsonData = parameters.toJSONData() else {
      throw NetworkingError.encodingFailed
    }
    
    return jsonData
  }

}

extension Encodable {

  func toJSONData() -> Data? {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return try? JSONEncoder().encode(self)
  }

}

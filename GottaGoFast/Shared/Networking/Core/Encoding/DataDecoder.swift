//
//  DataDecoder.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

protocol DataDecoder {
  static func decode<Model>(_ model: Model.Type, from data: Data) throws -> Model where Model: Decodable
}

final class JSONDataDecoder: DataDecoder {
  
  private static var decoder: JSONDecoder {
    let _decoder = JSONDecoder()
    _decoder.keyDecodingStrategy = .convertFromSnakeCase
    return _decoder
  }
  
  static func decode<Model>(
    _ model: Model.Type,
    from data: Data
  ) throws -> Model where Model : Decodable {
    
    guard let decodedData = try? decoder.decode(model, from: data) else {
      throw NetworkingError.decodingFailed
    }
    return decodedData
  }
  
}

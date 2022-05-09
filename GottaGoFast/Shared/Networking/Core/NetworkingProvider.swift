//
//  NetworkingProvider.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation
import UIKit

protocol NetworkingProviderType {

  func request<Model>(
    _ endpoint: EndpointType,
    completion: @escaping (Result<Model, NetworkingError>) -> Void
  ) where Model: Decodable
}

protocol NetworkIndicatorManager {
  var isNetworkActivityIndicatorVisible: Bool { get set }
}

final class NetworkingProvider: NetworkingProviderType {
  
  private let successCodeRange = 200..<300
  private let urlSession: URLSession
  private var networkIndicatorManager: NetworkIndicatorManager
  
  init(
    urlSession: URLSession = .shared,
    networkIndicatorManager: NetworkIndicatorManager = UIApplication.shared
  ) {
    self.urlSession = urlSession
    self.networkIndicatorManager = networkIndicatorManager
  }
  
  func request<Model>(
    _ endpoint: EndpointType,
    completion: @escaping (Result<Model, NetworkingError>) -> Void
  ) where Model : Decodable {

    do {
      let request = try endpoint.buildURLRequest()
      NSLog("Performing URL request: \(request)")

      let task =
      urlSession.dataTask(with: request) { [weak self] (data, response, error) in
        DispatchQueue.main.async {
          self?.networkIndicatorManager.isNetworkActivityIndicatorVisible = false
        }

        if let error = error {
          NSLog("URLRequest (\(request) failed with error: \(error)")
          completion(.failure(NetworkingError.invalidResponse))
          return
        }

        guard let self = self, let response = response as? HTTPURLResponse,
                self.successCodeRange ~= response.statusCode else {
          NSLog("URLRequest (\(request) failed with with invalid respose")
          completion(.failure(NetworkingError.invalidResponse))
          return
        }

        NSLog("Response: \(response)")
        
        guard let data = data else {
          completion(.failure(NetworkingError.invalidData))
          return
        }
        
        do {
          let model =  try JSONDataDecoder.decode(Model.self, from: data)
          completion(.success(model))
        } catch {
          completion(.failure(.invalidData))
        }
      }

      task.resume()
    } catch {
      completion(.failure(.invalidData))
    }
  }
}

extension UIApplication: NetworkIndicatorManager {}

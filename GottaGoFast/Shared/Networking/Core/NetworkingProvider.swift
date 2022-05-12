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
        guard let self = self else {
          NSLog("Self was dealocated - NetworkingProvider")
          completion(.failure(NetworkingError.invalidResponse))
          return
        }
        DispatchQueue.main.async {
          self.networkIndicatorManager.isNetworkActivityIndicatorVisible = false
        }

        if let error = error {
          NSLog("URLRequest \(request) failed with error: \(error)")
          completion(.failure(NetworkingError.invalidResponse))
          return
        }
        print(response as! HTTPURLResponse)
        print(String(decoding: data!, as: UTF8.self))
        
        guard let response = response as? HTTPURLResponse,
                self.successCodeRange ~= response.statusCode else {
          NSLog("URLRequest \(request) failed with invalid respose")
          completion(.failure(NetworkingError.invalidResponse))
          return
        }

        NSLog("Response: \(response)")
        
        guard let data = data else {
          completion(.failure(NetworkingError.invalidData))
          return
        }
        
        NSLog("Received data: \(String(decoding: data, as: UTF8.self))")
        
        do {
          let model =  try JSONDataDecoder.decode(Model.self, from: data)
          NSLog("Received model: \(model)")
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

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
  
  func refreshLogin(completion: @escaping (Result<EmptyResult, NetworkingError>) -> Void) {
    
    do {
      let refreshToken = try SecureStorageManager.shared.getData(type: .refreshToken)
      let request = try AuthenticationEndpoint.refreshLogin(refreshToken: refreshToken).buildURLRequest()
      
      let task =
      urlSession.dataTask(with: request) { [weak self] (data, response, error) in
        do {
          guard let self = self else {
            NSLog("Self was dealocated - NetworkingProvider")
            completion(.failure(NetworkingError.invalidResponse))
            return
          }
          
          if let error = error {
            NSLog("URLRequest \(request) failed with error: \(error)")
            completion(.failure(NetworkingError.invalidResponse))
            return
          }
          print(response as! HTTPURLResponse)
          print(String(decoding: data!, as: UTF8.self))
          
          guard let response = response as? HTTPURLResponse else {
            NSLog("URLRequest \(request) failed with invalid respose")
            completion(.failure(NetworkingError.invalidResponse))
            return
          }
          
          guard self.successCodeRange ~= response.statusCode else {
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
          
          let token =  try JSONDataDecoder.decode(RefreshedToken.self, from: data)
          NSLog("Received model: \(token)")
          
          try SecureStorageManager.shared.updateData(token.access, type: .accessToken)
          AppModeManager.shared.setAppMode(mode: .authenticated)
          completion(.success(EmptyResult()))
        } catch {
          AppModeManager.shared.setAppMode(mode: .notAuthenticated)
          completion(.failure(.unableToComplete))
        }
      }
      task.resume()
    } catch {
      AppModeManager.shared.setAppMode(mode: .notAuthenticated)
      completion(.failure(.invalidData))
    }
  }
                     
  
  func request<Model>(
    _ endpoint: EndpointType,
    completion: @escaping (Result<Model, NetworkingError>) -> Void
  ) where Model : Decodable {

    do {
      guard !SecureStorageManager.shared.isUserLoggedIn() ||
            SecureStorageManager.shared.isAccessTokenValid() else {
        refreshLogin() { result in
          switch result {
          case .success(_):
            NSLog("Successfully refreshed token -- provider")
            self.request(endpoint, completion: completion)
            
          case .failure(let error):
            NSLog("Refresh token failed Error \(error)")
            completion(.failure(.authenticationFailed))
          }
        }
        return
      }
      
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
        
        guard let response = response as? HTTPURLResponse else {
          NSLog("URLRequest \(request) failed with invalid respose")
          completion(.failure(NetworkingError.invalidResponse))
          return
        }

        guard self.successCodeRange ~= response.statusCode else {
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



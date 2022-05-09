//
//  EndpointType.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

protocol EndpointType {
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var needsAuthorization: Bool { get }
  var body: Encodable? { get }
}

extension EndpointType {
  
  private var defaultHeaders: [String: String] {
    return ["Content-Type": "application/json"]
  }
  
  private var baseURL: URL {
    return URL(string: "http://127.0.0.1:8000/")!
  }
  
  func buildURLRequest() throws -> URLRequest {
    var request = URLRequest(url: baseURL.appendingPathComponent(path))
    var httpHeaders = defaultHeaders

    if let headers = headers {
      httpHeaders = defaultHeaders.merging(headers) { (current, _) in current }
    }

    if needsAuthorization, let token = AuthenticationManager.shared.currentToken?.accessToken {
      httpHeaders["Authorization"] = "Bearer \(token)"
    }

    request.allHTTPHeaderFields = httpHeaders
    
    if let body = body {
      let httpBody = try JSONDataEncoder.encode(body)
      request.httpBody = httpBody
    }
    return request
  }
}


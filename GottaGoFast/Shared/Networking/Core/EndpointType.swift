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
  
  private var baseURL: String {
    return "http://127.0.0.1"
  }
  
  func buildURLRequest() throws -> URLRequest {
    var request = URLRequest(url: URL(string: baseURL.appending(path))!)
    var httpHeaders = defaultHeaders

    if let headers = headers {
      httpHeaders = defaultHeaders.merging(headers) { (current, _) in current }
    }

    if needsAuthorization, let token = AuthenticationManager.shared.currentToken?.access {
      httpHeaders["Authorization"] = "Bearer \(token)"
    }

    request.allHTTPHeaderFields = httpHeaders
    
    if let body = body {
      let httpBody = try JSONDataEncoder.encode(body)
      request.httpBody = httpBody
      print("httpbody", httpBody as? String)
      print(String(decoding: httpBody, as: UTF8.self))
    }
    request.httpMethod = method.rawValue
    return request
  }
}


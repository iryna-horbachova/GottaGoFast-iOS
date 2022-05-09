//
//  AuthenticationManager.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

final class AuthenticationManager {
  static let shared = AuthenticationManager()
  var currentToken: Token?
  
  private init() { }
}

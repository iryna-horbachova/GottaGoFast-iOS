//
//  Token.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

struct Token: Codable {
  let userId: Int
  let access: String
  let refresh: String
}

struct RefreshedToken: Codable {
  let access: String
}

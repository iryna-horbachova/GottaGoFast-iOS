//
//  Token.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

struct Token: Codable {
  let userId: Int
  let accessToken: String
  let refreshToken: String
}

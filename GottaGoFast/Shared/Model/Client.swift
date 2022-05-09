//
//  Client.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import Foundation

struct Client: Codable {
  let id: String?
  let user: User
  let rideDiscount: Int?
}

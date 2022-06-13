//
//  Geotag.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

struct Geotag: Codable {
  let _id: [String: String]?
  let userId: Int?
  let latitude: Double
  let longitude: Double
  let timestamp: String?
}



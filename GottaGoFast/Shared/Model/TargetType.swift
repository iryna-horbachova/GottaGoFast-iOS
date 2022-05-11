//
//  TargetType.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

enum TargetType: String {
  case driver = "GottaGoFastDriver"
  case client = "GottaGoFastClient"

  static func getCurrentTarget() -> TargetType {
    return TargetType(rawValue: Bundle.main.infoDictionary?["TargetName"] as? String ?? "") ?? .client
  }
}

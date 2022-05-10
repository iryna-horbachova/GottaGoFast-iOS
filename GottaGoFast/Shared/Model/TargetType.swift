//
//  TargetType.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

enum TargetType: String {
  case GottaGoFastDriver = "GottaGoFastDriver"
  case GottaGoFastClient = "GottaGoFastClient"

  func getCurrentTarget() -> String {
    return Bundle.main.infoDictionary?["TargetName"] as? String ?? ""
  }
}

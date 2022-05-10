//
//  AppModeManager.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation

class AppModeManager {

  private var appModeKey = "AppMode"

  static let shared = AppModeManager()
  private init() { }

  enum AppMode: String {
    case authenticated = "Authenticated"
    case notAuthenticated = "NotAuthenticated"
    case undefined = "Undefined"
    
    func getAppTarget() -> String {
      return Bundle.main.infoDictionary?["TargetName"] as? String ?? "GottaGoFast"
    }
  }

  func setAppMode(mode: AppMode) {
    UserDefaults.standard.set(mode.rawValue, forKey: appModeKey)
  }

  func getAppMode() -> AppMode {
    let value = UserDefaults.standard.object(forKey: appModeKey) as? String ?? ""
    return AppMode(rawValue: value) ?? AppMode.undefined
  }
}

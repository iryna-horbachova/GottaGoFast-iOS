//
//  SecureStorageManager.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import Foundation
import Security

enum KeychainError: Error {
    case noToken
    case unexpectedTokenData
    case unhandledError(status: OSStatus)
}

enum SecureStoreDataType: String {
  case accessToken = "AccessToken"
  case refreshToken = "RefreshToken"
  case userId = "UserId"
}

class SecureStorageManager {

  static let shared = SecureStorageManager()
  private let authenticationDateKey = "AuthenticationDate"

  private init() { }

  func addData(_ value: String, type: SecureStoreDataType) throws {
    let itemQuery: [String: Any] = [
      kSecValueData as String: value.data(using: String.Encoding.utf8)!,
      kSecAttrAccount as String: type.rawValue,
      kSecClass as String: kSecClassGenericPassword
    ]

    let status = SecItemAdd(itemQuery as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    UserDefaults.standard.set(Date(), forKey: authenticationDateKey)
  }

  func getData(type: SecureStoreDataType) throws -> String {
    let itemQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: type.rawValue,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(itemQuery as CFDictionary, &item)
    guard status != errSecItemNotFound else { throw KeychainError.noToken }
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    
    guard let existingItem = item as? [String : Any],
          let tokenData = existingItem[kSecValueData as String] as? Data,
          let token = String(data: tokenData, encoding: String.Encoding.utf8)
    else {
      throw KeychainError.unexpectedTokenData
    }
    return token
  }

  func updateData(_ newValue: String, type: SecureStoreDataType) throws {
    let itemQuery: [String: Any] = [
      kSecAttrAccount as String: type.rawValue,
      kSecClass as String: kSecClassGenericPassword
    ]

    let attributes: [String: Any] = [
        kSecValueData as String: newValue.data(using: .utf8)!
    ]

    let status = SecItemUpdate(
      itemQuery as CFDictionary,
      attributes as CFDictionary
    )

    guard status != errSecItemNotFound else {
      try addData(newValue, type: type)
      return
    }

    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
    UserDefaults.standard.set(Date(), forKey: authenticationDateKey)
  }
  
  func removeAllData() throws {
    UserDefaults.standard.removeObject(forKey: authenticationDateKey)
    
    let accessTokenQuery: [String: Any] = [
      kSecAttrAccount as String: SecureStoreDataType.accessToken.rawValue,
      kSecClass as String: kSecClassGenericPassword
    ]
    
    let refreshTokenQuery: [String: Any] = [
      kSecAttrAccount as String: SecureStoreDataType.refreshToken.rawValue,
      kSecClass as String: kSecClassGenericPassword
    ]
    
    let userIdQuery: [String: Any] = [
      kSecAttrAccount as String: SecureStoreDataType.userId.rawValue,
      kSecClass as String: kSecClassGenericPassword
    ]
    
    let accessTokenStatus = SecItemDelete(accessTokenQuery as CFDictionary)
    let refreshTokenStatus = SecItemDelete(refreshTokenQuery as CFDictionary)
    let userIdStatus = SecItemDelete(userIdQuery as CFDictionary)
    
    guard (accessTokenStatus == errSecSuccess || accessTokenStatus == errSecItemNotFound) &&
      (refreshTokenStatus == errSecSuccess || refreshTokenStatus == errSecItemNotFound) &&
      (userIdStatus == errSecSuccess || userIdStatus == errSecItemNotFound)
      else { throw KeychainError.unhandledError(status: accessTokenStatus) }
  }
  
  func isUserLoggedIn() -> Bool {
    guard UserDefaults.standard.object(forKey: authenticationDateKey) is Date else {
      return false
    }
    return true
  }
  
  func isAccessTokenValid() -> Bool {
    guard let date = UserDefaults.standard.object(forKey: authenticationDateKey) as? Date else {
      return false
    }
    if date.addingTimeInterval(86400) < Date() {
      return false
    }
    return true
  }
}

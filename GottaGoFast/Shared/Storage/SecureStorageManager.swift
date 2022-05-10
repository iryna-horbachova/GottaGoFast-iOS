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
}

class SecureStorageManager {

  static let shared = SecureStorageManager()
  
  private init() { }

  func addIdentityData(_ value: String, type: SecureStoreDataType) throws {
    let itemQuery = [
      kSecValueData: value.data(using: .utf8)!,
      kSecAttrAccount: type.rawValue,
      kSecClass: kSecClassIdentity
    ] as CFDictionary

    let status = SecItemAdd(itemQuery as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
  }

  func getIdentityData(type: SecureStoreDataType) throws -> String {
    let itemQuery: [String: Any] = [kSecClass as String: kSecClassIdentity,
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

  func updateIdentityData(newValue: String, type: SecureStoreDataType) throws {
    let itemQuery: [String: Any] = [
      kSecAttrAccount as String: type.rawValue,
      kSecClass as String: kSecClassIdentity
    ]

    let attributes: [String: Any] = [
        kSecValueData as String: newValue.data(using: .utf8)!
    ]

    let status = SecItemUpdate(
      itemQuery as CFDictionary,
      attributes as CFDictionary
    )

    guard status != errSecItemNotFound else {
        throw KeychainError.noToken
    }

    guard status == errSecSuccess else {
        throw KeychainError.unhandledError(status: status)
    }
  }
}

//
//  NetworkingService.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 09.05.2022.
//

import Foundation

class NetworkingService {
    final let provider: NetworkingProviderType
    
    init(provider: NetworkingProviderType = NetworkingProvider()) {
        self.provider = provider
    }
}

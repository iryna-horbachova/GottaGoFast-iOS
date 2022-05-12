//
//  UIViewController+Extensions.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import Foundation
import UIKit

extension UIViewController {
  func performTransition(to vc: UIViewController) {
    let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    
    guard let window = window else {
        return
    }

    window.rootViewController = vc
    window.makeKeyAndVisible()

    let options: UIView.AnimationOptions = .transitionCrossDissolve
    let duration: TimeInterval = 0.3
    UIView.transition(
      with: window, duration: duration,
      options: options, animations: nil, completion: nil
    )
  }
}

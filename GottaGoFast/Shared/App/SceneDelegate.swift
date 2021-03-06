//
//  SceneDelegate.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 08.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {


  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.windowScene = windowScene
    
    let appMode = AppModeManager.shared.getAppMode()
    
    switch appMode {
    case .authenticated:
      NSLog("Authenticated")
      window?.rootViewController = TargetType.getCurrentTarget() == TargetType.client ?
      ClientTabBarController() : DriverTabBarController()
    case .notAuthenticated, .undefined:
      NSLog("Not authenticated")
      window?.rootViewController = SignInViewController(nibName: "SignInViewController", bundle: .main) 
    }
    do {
      print(try SecureStorageManager.shared.getData(type: .accessToken))
    }
    catch {
      print("Error")
    }
    
    
    window?.makeKeyAndVisible()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    if TargetType.getCurrentTarget() == .driver {
      do {
        let driverId = try Int(SecureStorageManager.shared.getData(type: .userId))!
        AuthenticationService().updateDriverStatus(id: driverId, status: "I") { result in
          switch result {
          case .success(_):
            NSLog("Updated driver status to inactive!")
          case .failure(let error):
            NSLog("Updating driver status failed with error: \(error.localizedDescription)")
          }
        }
      } catch {
        NSLog("Unable to update driver status due to invalid driver id")
      }
    }
  }

}


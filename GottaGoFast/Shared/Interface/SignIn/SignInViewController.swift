//
//  SignInViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 10.05.2022.
//

import UIKit

class SignInViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  // TODO: Refactor
  var viewModel: SignInViewModel!
  
  var isSignedIn = false {
    didSet {
      if isSignedIn {
        NSLog("User signed in -- your VC")
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = SignInViewModel(viewController: self)

  }

  @IBAction func tappedSignInButton(_ sender: UIButton) {
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      present(
        UIAlertController.alertWithOKAction(
          title: "Error!",
          message: "Input can not be empty!"),
        animated: true
      )
      return
    }

    if !(viewModel.inputIsValid(email: email, password: password)) {
      present(
        UIAlertController.alertWithOKAction(
          title: "Error!",
          message: "Invalid input"),
        animated: true
      )
    }
    
    viewModel.performSignIn(email: email, password: password)
    
  }
  
}

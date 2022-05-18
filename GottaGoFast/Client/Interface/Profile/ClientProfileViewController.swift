//
//  ClientProfileViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 12.05.2022.
//

import UIKit

class ClientProfileViewController: UIViewController {
  
  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var lastNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var phoneNumberLabel: UILabel!
  
  var viewModel: ClientProfileViewModel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel = ClientProfileViewModel(viewController: self)
    viewModel.fetchProfileDetails()
    
    title = "title.profile".localized
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func updateProfileDetails() {
    firstNameLabel.text = viewModel.client?.user.firstName
    lastNameLabel.text = viewModel.client?.user.lastName
    emailLabel.text = viewModel.client?.user.email
    phoneNumberLabel.text = viewModel.client?.user.phoneNumber
  }
  @IBAction func tappedLogoutButton(_ sender: UIButton) {
    viewModel.logout()
    performTransition(to: SignInViewController(nibName: "SignInViewController", bundle: .main))
  }
  
}

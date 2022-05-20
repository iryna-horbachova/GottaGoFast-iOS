//
//  ModalViewController.swift
//  GottaGoFast
//
//  Created by Iryna Horbachova on 17.05.2022.
//

import UIKit

class ModalViewController: UIViewController {

  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 16
    view.clipsToBounds = true
    view.tag = 100
    return view
  }()
  
  let maxDimmedAlpha: CGFloat = 0.3
  lazy var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = maxDimmedAlpha
    return view
  }()

  let defaultHeight: CGFloat = 300
  let dismissibleHeight: CGFloat = 200
  let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
  var currentContainerHeight: CGFloat = 300
  
  var containerViewHeightConstraint: NSLayoutConstraint?
  var containerViewBottomConstraint: NSLayoutConstraint?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
    setupPanGesture()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateShowDimmedView()
    animatePresentContainer()
  }
  
  func setupView() {
    view.backgroundColor = .clear
  }
  
  func setupConstraints() {
    view.addSubview(dimmedView)
    view.addSubview(containerView)
    dimmedView.translatesAutoresizingMaskIntoConstraints = false
    containerView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
 
    containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
    containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)

    containerViewHeightConstraint?.isActive = true
    containerViewBottomConstraint?.isActive = true
  }
  
  func animatePresentContainer() {
    print("Animate present")
    UIView.animate(withDuration: 0.3) {
      self.containerViewBottomConstraint?.constant = 0
      self.view.layoutIfNeeded()
    }
  }
  
  func animateShowDimmedView() {
    dimmedView.alpha = 0
    UIView.animate(withDuration: 0.4) {
      self.dimmedView.alpha = self.maxDimmedAlpha
    }
  }

  func setupPanGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
    panGesture.delaysTouchesBegan = false
    panGesture.delaysTouchesEnded = false
    view.addGestureRecognizer(panGesture)
  }

  @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    
    let isDraggingDown = translation.y > 0
    
    let newHeight = currentContainerHeight - translation.y
    
    switch gesture.state {
    case .changed:
      if newHeight < maximumContainerHeight {
        containerViewHeightConstraint?.constant = newHeight
        view.layoutIfNeeded()
      }
    case .ended:
      // Condition 1: If new height is below min, dismiss controller
      if newHeight < dismissibleHeight {
        self.animateDismissView()
      }
      else if newHeight < defaultHeight {
        // Condition 2: If new height is below default, animate back to default
        animateContainerHeight(defaultHeight)
      }
      else if newHeight < maximumContainerHeight && isDraggingDown {
        // Condition 3: If new height is below max and going down, set to default height
        animateContainerHeight(defaultHeight)
      }
      else if newHeight > defaultHeight && !isDraggingDown {
        // Condition 4: If new height is below max and going up, set to max height at top
        animateContainerHeight(maximumContainerHeight)
      }
    default:
      break
    }
  }

  func animateContainerHeight(_ height: CGFloat) {
    UIView.animate(withDuration: 0.4) {
      self.containerViewHeightConstraint?.constant = height
      self.view.layoutIfNeeded()
    }
    currentContainerHeight = height
  }
  
  func animateDismissView() {
    UIView.animate(withDuration: 0.3) {

      self.containerViewBottomConstraint?.constant = self.defaultHeight
      self.view.layoutIfNeeded()
    }

    UIView.animate(withDuration: 0.4) {
      self.dimmedView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }
  
  func setupContentView(_ contentView: UIView) {
    containerView.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
      contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
      contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
    ])
  }
  
  func clearContainerView() {
    containerView.subviews.forEach({ $0.removeFromSuperview() })
  }
}

extension ModalViewController {
  func makeActionButton() -> UIButton {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.layer.cornerRadius = 10
    button.setTitle("Action button", for: .normal)
    button.titleLabel?.font = .preferredFont(forTextStyle: .body)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
  
  func makeTitleLabel() -> UILabel {
    let label = UILabel()
    label.text = "Title"
    label.font = .preferredFont(forTextStyle: .title1)
    return label
  }
}

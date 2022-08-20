//
//  LogInViewController.swift
//  DSKit
//
//  Docs https://dskit.app/components
//  Get started: https://dskit.app/get-started
//  Layout: https://dskit.app/layout
//  Appearance: https://dskit.app/appearance
//
//  Created by Borinschi Ivan on 02.03.2021.
//

import DSKit
import UIKit

// MARK: - LogInViewController

open class LogInViewController: DSViewController {
  // MARK: Open

  open override func viewDidLoad() {
    super.viewDidLoad()
    showContent()
    showBottomContent()
  }

  // MARK: Internal

  // Show content
  func showContent() {
    // Text
    let space1 = DSSpaceVM(type: .custom(50))
    let composer = DSTextComposer(alignment: .center)

    composer.add(
      image: Asset.Assets.logo.image,
      size: .init(width: 80, height: 80),
      spacing: 25)

    composer.add(
      sfSymbol: "circle.stack.3d.down.right.fill",
      style: .custom(size: 60, weight: .medium),
      tint: .headline,
      spacing: 50)

    composer.add(type: .body, text: "Meet new people from over millions of users. Create posts, find friends and more.")
    let text = composer.textViewModel()

    // Text section
    let section = [space1, text].list()
    section.doubleMarginLeftRightInsets()

    // Show text section
    show(content: section)
  }

  // Show bottom content
  func showBottomContent() {
    let emailLabel = DSLabelVM(
      .subheadline,
      text: "or sign up with Email",
      alignment: .center)

    // Facebook
    var apple = DSButtonVM(
      title: "Sign in with Apple",
      icon: UIImage(named: "apple"),
      textAlignment: .left)
    { [unowned self] _ in
      self.dismiss()
    }

    apple.imagePosition = .left

    // Twitter
    var google = DSButtonVM(
      title: "Sign in with Google",
      icon: UIImage(named: "google"),
      textAlignment: .left)
    { [unowned self] _ in
      self.dismiss()
    }

    google.imagePosition = .left

    // Sign up
    var signUpEmail = DSButtonVM(
      title: "Sign Up",
      icon: UIImage(systemName: "envelope.fill"),
      type: .secondaryView,
      textAlignment: .left)
    { [unowned self] _ in
      self.dismiss()
    }

    // Log in with email
    let logInWithEmail = DSButtonVM(
      title: "Log in with Email",
      type: .link,
      textAlignment: .center)
    { [unowned self] _ in
      self.dismiss()
    }

    signUpEmail.imagePosition = .rightMargin

    // Show bottom button
    showBottom(content: [
      [apple, google].list().doubleMarginLeftRightInsets(),
      [emailLabel].list(),
      [signUpEmail].list().doubleMarginLeftRightInsets(),
      [logInWithEmail].list(),
    ])
  }
}

// MARK: - SwiftUI Preview

import SwiftUI

// MARK: - LogInViewControllerPreview

struct LogInViewControllerPreview: PreviewProvider {
  static var previews: some View {
    Group {
      PreviewContainer(VC: LogInViewController(), BlackToneAppearance()).edgesIgnoringSafeArea(.all)
    }
  }
}

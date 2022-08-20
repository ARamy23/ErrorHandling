//
//  LoginViewModel.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 20/08/2022.
//

import Combine

// MARK: - LoginViewModel

public class LoginViewModel {
  // MARK: Lifecycle

  init() {
    bind()
  }

  // MARK: Internal

  func attemptAppleSignIn() {
    appleViewModel.attemptSignIn()
  }

  // MARK: Private

  private let appleViewModel: AppleSignInViewModel = .init()
  private var cancellables = Set<AnyCancellable>()
}

extension LoginViewModel {
  private func bind() {
    appleViewModel.$state.sink {
      print($0)
    }.store(in: &cancellables)
  }
}

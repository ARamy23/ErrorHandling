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
    state = .init()
    appleViewModel = .init()
    bind()
  }

  // MARK: Internal

  @Published var state: State = .init()

  func attemptAppleSignIn() {
    appleViewModel.attemptSignIn()
  }

  // MARK: Private

  private let appleViewModel: AppleSignInViewModel
  private var cancellables = Set<AnyCancellable>()
}

extension LoginViewModel {
  struct State {
    var error: PresentationError?
  }
}

extension LoginViewModel {
  private func bind() {
    appleViewModel.$state.sink { state in
      switch state {
      case .failure(let error):
        self.state.error = error
      default:
        // TODO: - Later
        break
      }
    }.store(in: &cancellables)
  }
}

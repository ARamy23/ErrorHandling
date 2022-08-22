//
//  AppleLoginViewModel.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 20/08/2022.
//

import AuthenticationServices
import Utils

// MARK: - AppleSignInViewModel

public class AppleSignInViewModel {
  // MARK: Lifecycle

  public init() { }

  public init(uiDelegate: AppleAuthUIDelegateProtocol) {
    self.uiDelegate = uiDelegate
  }

  // MARK: Public

  @Published public var state: State = .idle

  public func attemptSignIn() {
    let request = ASAuthorizationAppleIDProvider().createRequest().then { $0.requestedScopes = [.fullName] }
    let authController = ASAuthorizationController(authorizationRequests: [request])
    authController.delegate = uiDelegate
    authController.performRequests()
  }

  // MARK: Private

  private lazy var uiDelegate: AppleAuthUIDelegateProtocol = AppleAuthUIDelegate(
    onSuccess: onSuccessHandler,
    onError: onErrorHandler)

  private lazy var onSuccessHandler: VoidCallback = { [weak self] in
    guard let self = self else { return }
    self.state = .success(SuccessMessage(title: "Authenticated!"))
  }

  private lazy var onErrorHandler: Callback<ASAuthorizationError> = { [weak self] error in
    guard let self = self else { return }
    guard error.code != .canceled else { return }
    self.state = .failure(.init(error))
  }
}

extension AppleSignInViewModel {
  public enum State {
    case idle
    case success(SuccessMessage)
    case failure(AppleSignInError)
  }
}

// MARK: - AppleAuthUIDelegateProtocol

public protocol AppleAuthUIDelegateProtocol: ASAuthorizationControllerDelegate {
  var onSuccess: VoidCallback { get set }
  var onError: Callback<ASAuthorizationError> { get set }
}

// MARK: - AppleAuthUIDelegate

public final class AppleAuthUIDelegate: NSObject, AppleAuthUIDelegateProtocol {
  // MARK: Lifecycle

  public init(onSuccess: @escaping VoidCallback, onError: @escaping Callback<ASAuthorizationError>) {
    self.onSuccess = onSuccess
    self.onError = onError
  }

  // MARK: Public

  public var onSuccess: VoidCallback
  public var onError: Callback<ASAuthorizationError>

  public func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization _: ASAuthorization) {
    onSuccess()
  }

  public func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
    guard let error = error as? ASAuthorizationError else {
      onError(.init(.unknown))
      return
    }

    onError(error)
  }
}

extension AppleSignInError {
  init(_ authError: ASAuthorizationError) {
    switch authError.code {
    case .unknown:
      self = .init(title: "Something went wrong", description: "with an unknown reason")
    default:
      self = .init(title: "Sign in failed")
    }
  }
}

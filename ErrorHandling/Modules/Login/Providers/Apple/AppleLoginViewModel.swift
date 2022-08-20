//
//  AppleLoginViewModel.swift
//  ErrorHandling
//
//  Created by Ahmed Ramy on 20/08/2022.
//

import AuthenticationServices
import Utils

// MARK: - AppleSignInError

struct AppleSignInError: PresentationError {
  let title: String
  let description: String?
  let type: PresentationMethod
  let icon: UIImage?

  init(title: String, description: String? = nil, type: PresentationMethod = .indicator, icon: UIImage? = nil) {
    self.title = title
    self.description = description
    self.type = type
    self.icon = icon
  }
}

// MARK: - AppleSignInViewModel

class AppleSignInViewModel {
  // MARK: Lifecycle

  init() { }

  init(uiDelegate: AppleAuthUIDelegateProtocol) {
    self.uiDelegate = uiDelegate
  }

  // MARK: Internal

  @Published var state: State = .idle

  func attemptSignIn() {
    let request = [ASAuthorizationAppleIDProvider().createRequest().then { $0.requestedScopes = [.fullName] }]
    let authController = ASAuthorizationController(authorizationRequests: request)
    authController.delegate = uiDelegate
    authController.performRequests()
  }

  // MARK: Private

  private lazy var uiDelegate: AppleAuthUIDelegateProtocol = AppleAuthUIDelegate(
    onSuccess: onSuccessHandler,
    onError: onErrorHandler)

  private lazy var onSuccessHandler: VoidCallback = { [weak self] in
    guard let self = self else { return }
    self.state = .success
  }

  private lazy var onErrorHandler: Callback<ASAuthorizationError> = { [weak self] error in
    guard let self = self else { return }
    self.state = .failure(
      AppleSignInError(title: error.localizedDescription))
  }
}

extension AppleSignInViewModel {
  enum State {
    case idle
    case success
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

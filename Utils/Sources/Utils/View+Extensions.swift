//
//  View+Extensions.swift
//
//
//  Created by Ahmed Ramy on 19/01/2022.
//

import SwiftUI

extension View {
  public func fill() -> some View {
    frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  public func fillOnLeading() -> some View {
    frame(maxWidth: .infinity, alignment: .leading)
  }

  public func fillOnTrailing() -> some View {
    frame(maxWidth: .infinity, alignment: .trailing)
  }

  public func fillAndCenter() -> some View {
    frame(maxWidth: .infinity, alignment: .center)
  }

  public func getSafeArea() -> UIEdgeInsets {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
      .windows.first?.safeAreaInsets ?? .zero
  }

  @ViewBuilder
  public func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  @ViewBuilder
  public func stay(_ scheme: ColorScheme) -> some View {
    environment(\.colorScheme, scheme)
  }
}

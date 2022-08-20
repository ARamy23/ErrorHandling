//
//  ItemDetailsViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 02.03.2021.
//

import DSKit
import DSKitFakery
import Utils

// MARK: - ItemDetailsViewController

open class ItemDetailsViewController: DSViewController {
  // MARK: Open

  open override func viewDidLoad() {
    super.viewDidLoad()
    title = "Details"

    // Like
    let like = UIBarButtonItem(
      image: UIImage(systemName: "heart"),
      style: .plain,
      target: self,
      action: #selector(likeAction))

    // Filter
    let share = UIBarButtonItem(
      image: UIImage(systemName: "square.and.arrow.up"),
      style: .plain,
      target: self,
      action: #selector(shareAction))

    // Sort
    let wishlist = UIBarButtonItem(
      image: UIImage(systemName: "text.badge.plus"),
      style: .plain,
      target: self,
      action: #selector(wishList))

    navigationItem.rightBarButtonItems = [like, share, wishlist]

    update()
  }

  // MARK: Internal

  @objc
  func shareAction() {
    dismiss()
  }

  @objc
  func likeAction() {
    dismiss()
  }

  @objc
  func wishList() {
    dismiss()
  }

  func update() {
    // Show content
    show(content: [
      picturesGallerySection(),
      productInfoSection(),
      priceSection(),
      colorAndSizeSection(),
      descriptionSection(),
    ])

    // Add to cart button
    let addToCart = DSButtonVM(title: "Buy with", icon: UIImage(named: "ApplePay"), imagePosition: .right) { [unowned self] _ in
      self.dismiss()
    }

    // Show bottom content
    showBottom(content: addToCart)
  }
}

// MARK: - Sections
extension ItemDetailsViewController {
  /// Product info section
  /// - Returns: DSSection
  func productInfoSection() -> DSSection {
    let composer = DSTextComposer()
    composer.add(type: .title2, text: "Women's Running Shoe")
    composer.add(type: .subheadline, text: "Nike Revolution 5")

    return [composer.textViewModel()].list().zeroTopInset()
  }

  /// Color && Size
  /// - Returns: DSSection
  func colorAndSizeSection() -> DSSection {
    let color = DSActionVM(title: "Color")
    let size = DSActionVM(title: "Size")

    return [color, size].grid()
  }

  /// Price section
  /// - Returns: DSSection
  func priceSection() -> DSSection {
    // Text
    let text = DSTextComposer()
    text.add(price: DSPrice.random(), size: .large, newLine: false)

    // Action
    var action = DSActionVM(composer: text)
    action.style.displayStyle = .default
    action.height = .absolute(30)

    // Picker
    let picker = DSQuantityPickerVM(quantity: 1)
    picker.width = .absolute(120)
    picker.height = .absolute(35)

    // Supplementary view
    let supView = picker.asSupplementary(
      position: .rightCenter,
      insets: .small,
      offset: .custom(.init(x: -5, y: 0)))

    action.supplementaryItems = [supView]

    return action.list()
  }

  /// Description
  /// - Returns: DSSection
  func descriptionSection() -> DSSection {
    let text = """
      The Nike Revolution 5 cushions your stride with soft foam to keep you running in comfort. Lightweight knit
      material wraps your foot in breathable support, while a minimalist design fits in anywhere your day takes you.
      """

    let label = DSLabelVM(.callout, text: text, alignment: .left)

    return [label].list()
  }

  /// Gallery section
  /// - Returns: DSSection
  func picturesGallerySection() -> DSSection {
    let urls = [
      p1Image,
      p2Image,
      p3Image,
    ].compactMap({ $0 })

    let pictureModels = urls.map { url -> DSViewModel in
      DSImageVM(imageUrl: url, height: .absolute(300), displayStyle: .themeCornerRadius)
    }

    let pageControl = DSPageControlVM(type: .viewModels(pictureModels))
    return pageControl.list().zeroLeftRightInset()
  }
}

// MARK: - SwiftUI Preview

import SwiftUI

// MARK: - ItemDetailsViewControllerPreview

struct ItemDetailsViewControllerPreview: PreviewProvider {
  static var previews: some View {
    Group {
      let nav = DSNavigationViewController(rootViewController: ItemDetailsViewController())
      PreviewContainer(VC: nav, DSKitAppearance()).edgesIgnoringSafeArea(.all)
    }
  }
}

private let p1Image =
  URL(
    string: "https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?cs=srgb&dl=pexels-melvin-buezo-2529148.jpg&fm=jpg")
private let p2Image =
  URL(
    string: "https://images.pexels.com/photos/3261069/pexels-photo-3261069.jpeg?cs=srgb&dl=pexels-wallace-chuck-3261069.jpg&fm=jpg")
private let p3Image =
  URL(string: "https://images.pexels.com/photos/5710082/pexels-photo-5710082.jpeg?cs=srgb&dl=pexels-ox-street-5710082.jpg&fm=jpg")

// MARK: - DSButtonVM + Then

extension DSButtonVM {
  /// Init button view model
  /// - Parameters:
  ///   - title: Button text
  ///   - type: DSButtonVMType
  ///   - handleDidTap: Handle did tap
  public init(
    title: String? = nil,
    icon: UIImage? = nil,
    type: DSButtonVMType = .default,
    textAlignment: NSTextAlignment = .center,
    imagePosition: DSButtonVMImagePosition = .left,
    didTap handleDidTap: ((DSButtonVM) -> Void)? = nil)
  {
    self.init(title: title, icon: icon, type: type, textAlignment: textAlignment, didTap: handleDidTap)
    self.imagePosition = imagePosition
  }
}

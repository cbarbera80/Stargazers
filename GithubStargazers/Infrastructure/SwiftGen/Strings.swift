// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Home {
    /// Search
    internal static let title = L10n.tr("Localizable", "home.title")
    internal enum RepoTLabel {
      /// Repository
      internal static let text = L10n.tr("Localizable", "home.repoTLabel.text")
    }
    internal enum RepoTextField {
      /// Insert repository's name
      internal static let text = L10n.tr("Localizable", "home.repoTextField.text")
    }
    internal enum SearchButton {
      /// Search
      internal static let title = L10n.tr("Localizable", "home.searchButton.title")
    }
    internal enum ShowResults {
      /// Show results
      internal static let text = L10n.tr("Localizable", "home.showResults.text")
      internal enum NoData {
        /// No data found
        internal static let text = L10n.tr("Localizable", "home.showResults.noData.text")
      }
    }
    internal enum UserLabel {
      /// User
      internal static let text = L10n.tr("Localizable", "home.userLabel.text")
    }
    internal enum UserTextField {
      /// Insert user's name
      internal static let text = L10n.tr("Localizable", "home.userTextField.text")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

import UIKit

protocol ReusableSupplementaryView: AnyObject {
    static var kind: String { get }
}

extension ReusableSupplementaryView where Self: UIView {
    static var kind: String {
        return "kind_\(String(describing: self))"
    }
}

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

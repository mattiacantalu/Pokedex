import Foundation
import UIKit

extension UIView {
    func insert(in container: UIView, inset: UIEdgeInsets = .zero) {
        container.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [topAnchor.constraint(equalTo: container.topAnchor, constant: inset.top),
             leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: inset.left),
             trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: inset.right),
             bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: inset.bottom)]
        )
    }
}

//  UIView+Embedding.swift - Embedding Views with Layout Constraints

import UIKit

extension UIView {
    func embedd(view: UIView, withInsets insets: UIEdgeInsets = UIEdgeInsets.zero, layoutGuide: UILayoutGuide? = nil) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        let constraints: [NSLayoutConstraint]
        if let layoutGuide = layoutGuide {
            constraints = [ view.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.left),
                            view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: insets.right),
                            view.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
                            view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: insets.bottom)]
        } else {
            constraints = [ view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left),
                            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: insets.right),
                            view.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
                            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom)]
        }
        NSLayoutConstraint.activate(constraints)
    }

    func wrapped(withInsets insets: UIEdgeInsets = UIEdgeInsets.zero, horizontalHuggingPriority priority: UILayoutPriority? = nil) -> UIView {
        let wrapper = UIView()
        wrapper.embedd(view: self, withInsets: insets)
        if let priority = priority {
            wrapper.setContentHuggingPriority(priority, for: .horizontal)
        }
        return wrapper
    }
}

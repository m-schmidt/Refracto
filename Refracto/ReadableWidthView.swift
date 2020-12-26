//  ReadableWidthView.swift

import UIKit

class ReadableWidthView: UIView {
    private var firstLayout = true

    override func layoutSubviews() {
        super.layoutSubviews()
        if firstLayout {
            firstLayout = false
            handleTraitChange()
        }
    }

    var regularConstraints: [NSLayoutConstraint] = []
    var compactConstraints: [NSLayoutConstraint] = []

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            handleTraitChange()
        }
    }

    private func handleTraitChange() {
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        }
    }

    func embedd(readableSubview view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        regularConstraints = [
            view.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor) ]

        compactConstraints = [
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor) ]

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}

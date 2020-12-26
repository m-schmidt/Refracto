//  RefractionInputLabel.swift

import UIKit

fileprivate let labelFontSize: CGFloat = 13.0

class RefractionInputLabel: UICollectionReusableView {
    static let identifier = "RefractionInputLabel"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        label.textColor = Colors.inputForeground
        label.backgroundColor = Colors.inputBackground
        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .light).monospacedDigitFontVariant
        label.textAlignment = .center
        label.isAccessibilityElement = false
        embedd(view: label)
    }

    func configure(text: String) {
        label.text = text
    }
}

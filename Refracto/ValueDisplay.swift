//  ValueView.swift

import UIKit

fileprivate let valueFontSize: CGFloat = 22.0
fileprivate let labelFontSize: CGFloat = 12.0
fileprivate let unitFontSize: CGFloat = 18.0

class ValueDisplay: UIView {
    private let label = UILabel()
    private let value = UILabel()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = Colors.displayBackground
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        setContentHuggingPriority(.defaultLow, for: .vertical)
        isAccessibilityElement = true

        value.font = UIFont.systemFont(ofSize: valueFontSize).monospacedDigitFontVariant
        value.backgroundColor = Colors.displayBackground
        value.textAlignment = .center
        value.textColor = Colors.displayForeground
        value.translatesAutoresizingMaskIntoConstraints = false
        value.isAccessibilityElement = false
        addSubview(value)

        label.font = UIFont.systemFont(ofSize: labelFontSize, weight: .light)
        label.textAlignment = .center
        label.backgroundColor = Colors.displayBackground
        label.textColor = Colors.displaySecondaryForeground
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = false
        addSubview(label)

        NSLayoutConstraint.activate([
            value.leadingAnchor.constraint(equalTo: leadingAnchor),
            value.trailingAnchor.constraint(equalTo: trailingAnchor),
            value.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: centerYAnchor, constant: 6) ])
    }

    func setLabel(_ text: String) {
        label.text = text
        accessibilityLabel = text
    }

    func setValue(_ val: Double, formattedWith formatter: NumberFormatter, accessibilityFormatter: NumberFormatter? = nil) {
        value.attributedText = formatter.formattedAttributedString(for: val, unitColor: Colors.displaySecondaryForeground, unitFontSize: unitFontSize)

        let formatter = accessibilityFormatter ?? formatter
        let val = formatter.formattedString(for: val)

        if val == invalidValueSymbol {
            accessibilityValue = "AccessibilityOutOfRange".localized
        } else {
            accessibilityValue = val
        }
    }
}

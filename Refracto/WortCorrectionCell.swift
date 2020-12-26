//  WortCorrectionCell.swift

import UIKit

fileprivate let minimumWortFactor: Float = 1.0
fileprivate let maximumWortFactor: Float = 1.06

fileprivate let sliderInsets = UIEdgeInsets(top: 16, left: 16, bottom: -12, right: -16)

class WortCorrectionCell: SettingsBaseTableViewCell {
    static let identifier = "WortCorrectionCell"

    private var generator: UISelectionFeedbackGenerator? = nil

    private let hstack = UIStackView()
    private let label = UILabel()
    private let value = UILabel()
    private let slider = UISlider()

    override func setup() {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        contentView.embedd(view: stack, layoutGuide: contentView.layoutMarginsGuide)

        hstack.alignment = .center
        hstack.axis = .horizontal
        hstack.distribution = .fill
        hstack.spacing = 8
        stack.addArrangedSubview(hstack)

        label.textAlignment = .left
        label.textColor = Colors.settingsCellForeground
        label.isAccessibilityElement = false
        label.numberOfLines = 0
        hstack.addArrangedSubview(label.wrapped(withInsets: .zero, horizontalHuggingPriority: .defaultLow))

        value.textAlignment = .right
        value.textColor = Colors.settingsCellSecondaryForeground
        value.setContentHuggingPriority(.defaultLow, for: .horizontal)
        value.isAccessibilityElement = false
        hstack.addArrangedSubview(value)

        slider.minimumValue = minimumWortFactor
        slider.maximumValue = maximumWortFactor
        slider.maximumTrackTintColor = Colors.settingsTrack
        slider.thumbTintColor = Colors.settingsThumb
        slider.isAccessibilityElement = false

        slider.addTarget(self, action: #selector(editingBegan), for: .touchDown)
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(editingEnded), for: [.touchUpInside, .touchUpOutside])
        stack.addArrangedSubview(slider.wrapped(withInsets: sliderInsets))
    }

    func configure(isIntermediateUpdate: Bool = false) {
        label.text = "CorrectionTitle".localized
        label.font = UIFont.preferredFont(forTextStyle: .body)

        let factor = Settings.shared.wortCorrection
        value.text = Formatter.wortCorrection.formattedString(for: factor)
        value.font = UIFont.preferredFont(forTextStyle: .body).monospacedDigitFontVariant

        if isIntermediateUpdate == false {
            slider.setValue(Float(factor), animated: true)
        }

        updateAccessibility()
    }


    // MARK: Haptic Feedback

    @objc private func editingBegan() {
        generator = UISelectionFeedbackGenerator()
        generator?.prepare()
    }

    @objc private func valueChanged() {
        let oldFactor = Settings.shared.wortCorrection
        let newFactor = Double(round(slider.value * 200.0) / 200.0)
        guard fabs(oldFactor - newFactor) > Double.ulpOfOne else { return }

        if let generator = generator {
            generator.selectionChanged()
            generator.prepare()
        }

        Settings.shared.wortCorrection = newFactor
        self.configure(isIntermediateUpdate: true)
    }

    @objc private func editingEnded() {
        generator = nil
        self.configure()
    }
}


// MARK: - Dynamic Layout for Accessibility

extension WortCorrectionCell {
    override func updateConstraints() {
        if UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory {
            hstack.spacing = 1
            hstack.axis = .vertical
            hstack.alignment = .fill
            value.textAlignment = .left
        } else {
            hstack.spacing = 8
            hstack.axis = .horizontal
            hstack.alignment = .center
            value.textAlignment = .right
        }

        super.updateConstraints()
    }
}


// MARK: - Accessibility

extension WortCorrectionCell {
    private func updateAccessibility() {
        accessibilityLabel = "CorrectionTitle".localized
        accessibilityTraits = .adjustable
        isAccessibilityElement = true
    }

    override var accessibilityValue: String? {
        get {
            let factor = Settings.shared.wortCorrection
            return Formatter.accessibleWortCorrection.formattedString(for: factor)
        }
        set {
        }
    }

    override func accessibilityIncrement() {
        slider.accessibilityIncrement()
    }

    override func accessibilityDecrement() {
        slider.accessibilityDecrement()
    }
}

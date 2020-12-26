//  FormulaCell.swift

import UIKit

class FormulaInputCell: UICollectionViewCell {
    static let identifier = "FormulaInputCell"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        label.backgroundColor = Colors.formulaBackground
        label.textColor = Colors.formulaForeground
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.isAccessibilityElement = false
        embedd(view: label)
    }

    override var isSelected: Bool {
        didSet {
            let text = label.attributedText?.string ?? ""
            self.configure(text: text)
        }
    }

    func configure(text: String) {
        let attributes = Self.textAttributes(selected: self.isSelected)
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        UIView.transition(with: label,
                      duration: 0.2,
                       options: .transitionCrossDissolve,
                    animations: { [weak self] in
                        self?.label.attributedText = attributedText
                 })
    }
}


// MARK: - Text Attributes

fileprivate let fontSize: CGFloat = 17.0

extension FormulaInputCell {
    static func lineHeight() -> CGFloat {
        let standardHeight = UIFont.systemFont(ofSize: fontSize, weight: .semibold).lineHeight
        let selectedHeight = UIFont.systemFont(ofSize: fontSize, weight: .bold).lineHeight
        return max(standardHeight, selectedHeight)
    }

    static func textAttributes(selected: Bool) -> [NSAttributedString.Key:Any] {
        if selected {
            return [ .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
                     .foregroundColor: Colors.accent ]
        } else {
            return [ .font: UIFont.systemFont(ofSize: fontSize, weight: .semibold),
                     .foregroundColor: Colors.formulaForeground ]
        }
    }
}

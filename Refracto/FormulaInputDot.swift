//  FormulaInputDot.swift

import UIKit

fileprivate let dotDiameter: CGFloat = 9

class FormulaInputDot: UIView {
    init() {
        super.init(frame: .zero)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: dotDiameter, height: dotDiameter)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(Colors.formulaBackground.cgColor)
        context.fill(self.bounds)
        context.setFillColor(Colors.accent.cgColor)
        context.fillEllipse(in: self.bounds)
    }
}

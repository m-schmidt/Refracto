//  RefractionInputNeedle.swift

import UIKit

fileprivate let needleWidth: CGFloat = 90.0
fileprivate let needleHeadDiameter: CGFloat = 9.0

class RefractionInputNeedle: UIView {
    let alignment: RefractionPickerAlignment

    init(alignment: RefractionPickerAlignment) {
        self.alignment = alignment
        super.init(frame: .zero)

        isOpaque = false
        isUserInteractionEnabled = false
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: needleWidth, height: FormulaInput.noIntrinsicMetric)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let w = self.bounds.width
        let h = self.bounds.height
        let y = floor(h/2)

        let headRect = CGRect(x: alignment == .right ? 0 : w - needleHeadDiameter, y: ceil (y - needleHeadDiameter/2), width: needleHeadDiameter, height: needleHeadDiameter)
        let barRect = CGRect(x: 0, y: y, width: w, height: 1)

        context.setFillColor(UIColor.clear.cgColor)
        context.fill(self.bounds)

        context.setFillColor(Colors.accent.cgColor)
        context.fillEllipse(in: headRect)
        context.fill(barRect)
    }
}

//  SeparatorLine.swift - Separator Lines in Display and Input Area

import UIKit

class SeparatorLine: UIView {
    let color: UIColor

    enum Direction {
        case horizontal, vertical
    }
    let direction: Direction

    enum Size {
        case small, medium, full
    }
    let size: Size

    init(color: UIColor, direction: Direction = .horizontal, size: Size = .full) {
        self.color = color
        self.direction = direction
        self.size = size
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        isOpaque = false

        switch size {
        case .small:  alpha = 0.4
        case .medium: alpha = 0.6
        case .full:   alpha = 1.0
        }

        setContentHuggingPriority(.defaultHigh+1, for: .horizontal)
        setContentHuggingPriority(.defaultHigh+1, for: .vertical)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        if direction == .horizontal {
            return CGSize(width: UIView.noIntrinsicMetric, height: 1)
        } else {
            return CGSize(width: 1, height: UIView.noIntrinsicMetric)
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(UIColor.clear.cgColor)
        context.fill(self.bounds)

        let barRect: CGRect
        let w = self.bounds.width
        let h = self.bounds.height

        switch (direction, size) {
        case (.horizontal, .small):
            barRect = CGRect(x: rint(w*0.3), y: rint(h/2), width: rint(w*0.4), height: 1)
        case (.horizontal, .medium):
            barRect = CGRect(x: rint(w*0.1), y: rint(h/2), width: rint(w*0.8), height: 1)
        case (.horizontal, .full):
            barRect = CGRect(x: 0, y: rint(h/2), width: w, height: 1)

        case (.vertical, .small):
            barRect = CGRect(x: rint(w/2), y: rint(h*0.3), width: 1, height: rint(h*0.4))
        case (.vertical, .medium):
            barRect = CGRect(x: rint(w/2), y: rint(h*0.1), width: 1, height: rint(h*0.8))
        case (.vertical, .full):
            barRect = CGRect(x: rint(w/2), y: 0, width: 1, height: h)
        }

        context.setFillColor(color.cgColor)
        context.fill(barRect)
    }
}

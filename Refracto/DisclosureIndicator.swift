//  DisclosureIndicator.swift - Themeable Disclosure Indicator for UITableView

import UIKit

class DisclosureIndicator: UIView {
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 11, height: 18))
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(UIColor.clear.cgColor)
        context.fill(self.bounds)

        let x = self.bounds.maxX - 3
        let y = self.bounds.midY
        let r = CGFloat(4.5)

        context.move(to: CGPoint(x: x-r, y: y-r))
        context.addLine(to: CGPoint(x: x, y: y))
        context.addLine(to: CGPoint(x: x-r, y: y+r))
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(2)
        context.setStrokeColor(Colors.settingsCellSecondaryForeground.cgColor)
        context.strokePath()
    }
}

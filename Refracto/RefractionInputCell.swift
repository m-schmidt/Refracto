//  RefractometerInputCell.swift

import UIKit

enum RefractionPickerAlignment {
    case left, right
}

enum RefractionPickerBarWidth: Int {
    case small  = 20
    case medium = 32
    case large  = 52
}

class RefractionInputCell: UICollectionViewCell {
    static let identifier = "RefractionInputCell"

    var alignment: RefractionPickerAlignment = .left
    var width: RefractionPickerBarWidth = .small

    func configure(alignment:RefractionPickerAlignment, width: RefractionPickerBarWidth) {
        self.alignment = alignment
        self.width = width
        self.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let w = CGFloat(width.rawValue)
        let x = (alignment == .left) ? 0 : floor(bounds.width - w)
        let y = floor(bounds.height / 2)

        context.setFillColor(Colors.inputBackground.cgColor)
        context.fill(rect);

        context.setFillColor(Colors.inputForeground.cgColor)
        context.fill(CGRect(x: x, y: y, width: w, height: 1))
    }
}

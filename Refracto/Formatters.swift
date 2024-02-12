//  Formatters.swift - Formatters to Display Computed Values

import Foundation
import UIKit

let invalidValueSymbol: String = "—"

extension NumberFormatter {
    private var unitText: String? {
        guard let format = positiveFormat,
              let first = format.firstIndex(of: "'"),
              let last = format.lastIndex(of: "'"),
              first < last
            else { return nil }

        return String(format[first ..< last].dropFirst())
    }

    func formattedString(for value: Double) -> String {
        self.string(from: value as NSNumber) ?? invalidValueSymbol
    }

    func formattedAttributedString(for value: Double, unitColor: UIColor, unitFontSize size: CGFloat? = nil) -> NSAttributedString {
        let string = formattedString(for: value)
        let result = NSMutableAttributedString(string: string)
        if let unit = self.unitText, let range = string.range(of: unit) {
            let nsrange = NSRange(range, in: string)
            result.addAttribute(.foregroundColor, value: unitColor, range: nsrange)

            if let size = size {
                let font = UIFont.systemFont(ofSize: size, weight: .light)
                result.addAttribute(.font, value: font, range: nsrange)
            }
        }
        return result
    }
}

@MainActor
struct Formatter {
    static var brix: NumberFormatter = {
        formatter("#0.0")
    }()

    static var accessibleBrix: NumberFormatter = {
        formatter("AccessibilityBrixFormatter".localized)
    }()

    static var plato: NumberFormatter = {
        formatter("#0.0'\u{2009}°P'")
    }()

    static var accessiblePlato: NumberFormatter = {
        formatter("AccessibilityPlatoFormatter".localized)
    }()

    static var SG: NumberFormatter = {
        formatter("#0.000'\u{2009}SG'")
    }()

    static var attenuation: NumberFormatter = {
        formatter("#0'\u{2009}%'")
    }()

    static var abv: NumberFormatter = {
        formatter("#0.0'\u{2009}%'")
    }()

    static var wortCorrection: NumberFormatter = {
        formatter("'1\u{2009}\u{f7}\u{2009}'0.000")
    }()

    static var accessibleWortCorrection: NumberFormatter = {
        formatter("0.000")
    }()

    static func formatter(_ format: String) -> NumberFormatter {
        let f = NumberFormatter()
        f.positiveFormat = format
        f.locale = NSLocale.autoupdatingCurrent
        f.nilSymbol = invalidValueSymbol
        f.notANumberSymbol = invalidValueSymbol
        f.negativeInfinitySymbol = invalidValueSymbol
        f.positiveInfinitySymbol = invalidValueSymbol
        return f
    }
}

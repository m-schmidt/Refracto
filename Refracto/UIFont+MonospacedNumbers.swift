//  UIFont+MonospacedNumbers.swift

import UIKit

extension UIFont {
    var monospacedDigitFontVariant: UIFont {
        let descriptor = fontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: descriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let settings =
            [[ UIFontDescriptor.FeatureKey.type: kNumberSpacingType,
               UIFontDescriptor.FeatureKey.selector: kMonospacedNumbersSelector]
            ]
        let attributes = [UIFontDescriptor.AttributeName.featureSettings: settings]
        return self.addingAttributes(attributes)
    }
}

//  Colors.swift - Dynamic Providers for Theme Colors

import UIKit

@MainActor
final class Colors {
    fileprivate static func effectiveTheme(_ traits: UITraitCollection) -> Theme {
        if Settings.shared.theme == .System {
            if traits.userInterfaceStyle == .dark {
                return .Dark
            } else {
                return .Light
            }
        } else {
            return Settings.shared.theme
        }
    }

    static var accent: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0x66e5fe)
            case .Gray:
                return UIColor(hex: 0xbbd553)
            case .Steel:
                return UIColor(hex: 0xfe661a)
            case .YellowBlue:
                return UIColor(hex: 0xfde666)
            default:
                return UIColor(named: "AccentColor")!
            }
        }
    }

    static var barBackground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xfefefe)
            case .Blue:
                return UIColor(hex: 0x1f2533)
            case .Gray:
                return UIColor(hex: 0x2e3033)
            case .Steel:
                return UIColor(hex: 0x292e33)
            case .YellowBlue:
                return UIColor(hex: 0x1f2533)
            default:
                return .systemGroupedBackground
            }
        }
    }

    static func barShadowColor() -> UIColor? {
        switch Settings.shared.theme {
        case .Blue:
            return UIColor(hex: 0x36435a).withAlphaComponent(0.9)
        case .Gray:
            return UIColor(hex: 0x45484c).withAlphaComponent(0.9)
        case .Steel:
            return UIColor(hex: 0x53575c).withAlphaComponent(0.9)
        case .YellowBlue:
            return UIColor(hex: 0x4b515c).withAlphaComponent(0.9)
        default:
            return nil
        }
    }

    static var barForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0xfefefe)
            case .Gray:
                return UIColor(hex: 0xfefefe)
            case .Steel:
                return UIColor(hex: 0xfefefe)
            case .YellowBlue:
                return UIColor(hex: 0xfefefe)
            default:
                return .label
            }
        }
    }

    static var barSecondaryForeground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Blue:
                return UIColor(hex: 0x7a8998)
            case .Gray:
                return UIColor(hex: 0x899099)
            case .Steel:
                return UIColor(hex: 0xb7c1cb)
            case .YellowBlue:
                return UIColor(hex: 0xa1b8cb)
            default:
                return .systemGray
            }
        }
    }


    // MARK: Settings

    static var settingsBackground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xf4f4f4)
            case .Dark:
                return UIColor(hex: 0x050505)
            case .Blue:
                return UIColor(hex: 0x171c26)
            case .Gray:
                return UIColor(hex: 0x222426)
            case .Steel:
                return UIColor(hex: 0x1e2226)
            case .Black:
                return UIColor(hex: 0x050505)
            case .YellowBlue:
                return UIColor(hex: 0x171c26)
            default:
                return .systemGroupedBackground
            }
        }
    }

    static var settingsCellBackground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xfefefe)
            case .Blue:
                return UIColor(hex: 0x1f2533)
            case .Gray:
                return UIColor(hex: 0x2e3033)
            case .Steel:
                return UIColor(hex: 0x292e33)
            case .YellowBlue:
                return UIColor(hex: 0x1f2533)
            default:
                return .secondarySystemGroupedBackground
            }
        }
    }

    static var settingsCellSelectedBackground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xe9f4fe)
            case .Blue:
                return UIColor(hex: 0x2e384d)
            case .Gray:
                return UIColor(hex: 0x45484c)
            case .Steel:
                return UIColor(hex: 0x3d444c)
            case .YellowBlue:
                return UIColor(hex: 0x2e384d)
            default:
                return .systemGray4
            }
        }
    }

    static var settingsCellForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0xfefefe)
            case .Gray:
                return UIColor(hex: 0xfefefe)
            case .Steel:
                return UIColor(hex: 0xfefefe)
            case .YellowBlue:
                return UIColor(hex: 0xfefefe)
            default:
                return .label
            }
        }
    }

    static var settingsCellSecondaryForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0x7a8998)
            case .Gray:
                return UIColor(hex: 0x899099)
            case .Steel:
                return UIColor(hex: 0xb7c1cb)
            case .YellowBlue:
                return UIColor(hex: 0xa1b8cb)
            default:
                return .secondaryLabel
            }
        }
    }

    static var settingsCellDiabledForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0x7a8998)
            case .Gray:
                return UIColor(hex: 0x899099)
            case .Steel:
                return UIColor(hex: 0xb7c1cb)
            case .YellowBlue:
                return UIColor(hex: 0xa1b8cb)
            default:
                return .systemGray
            }
        }
    }

    static var settingsCellSeparator: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0x4b515c)
            case .Gray:
                return UIColor(hex: 0x45484c)
            case .Steel:
                return UIColor(hex: 0x3d444c)
            case .YellowBlue:
                return UIColor(hex: 0x2e384d)
            default:
                return .opaqueSeparator
            }
        }
    }

    static var settingsTrack: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0x2e384d)
            case .Gray:
                return UIColor(hex: 0x505459)
            case .Steel:
                return UIColor(hex: 0x475059)
            case .YellowBlue:
                return UIColor(hex: 0x364159)
            default:
                return .systemGray4
            }
        }
    }

    static var settingsThumb: UIColor {
        return UIColor(hex: 0xfefefe)
    }


    // MARK: Display Area

    static var displayBackground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xf4f4f4)
            case .Blue:
                return UIColor(hex: 0x1f2533)
            case .Gray:
                return UIColor(hex: 0x2e3033)
            case .Steel:
                return UIColor(hex: 0x292e33)
            case .YellowBlue:
                return UIColor(hex: 0x1f2533)
            default:
                return .systemBackground
            }
        }
    }

    static var displayForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0xfefefe)
            case .Gray:
                return UIColor(hex: 0xfefefe)
            case .Steel:
                return UIColor(hex: 0xfefefe)
            case .YellowBlue:
                return UIColor(hex: 0xfefefe)
            default:
                return .label
            }
        }
    }

    static var displaySecondaryForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0x7a8998)
            case .Gray:
                return UIColor(hex: 0x899099)
            case .Steel:
                return UIColor(hex: 0xb7c1cb)
            case .YellowBlue:
                return UIColor(hex: 0xa1b8cb)
            default:
                return .secondaryLabel
            }
        }
    }

    static var displaySeparator: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Dark:
                return UIColor(white: 0.4, alpha: 1.0)
            case .Blue:
                return UIColor(hex: 0x4b515c)
            case .Gray:
                return UIColor(hex: 0x45484C)
            case .Steel:
                return UIColor(hex: 0x3d444c)
            case .YellowBlue:
                return UIColor(hex: 0x2e384d)
            default:
                return .opaqueSeparator
            }
        }
    }


    // MARK: Formula Area

    static var formulaBackground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xf4f4f4)
            case .Blue:
                return UIColor(hex: 0x1f2533)
            case .Gray:
                return UIColor(hex: 0x2e3033)
            case .Steel:
                return UIColor(hex: 0x292e33)
            case .YellowBlue:
                return UIColor(hex: 0x1f2533)
            default:
                return .systemBackground
            }
        }
    }

    static var formulaForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0xfefefe)
            case .Gray:
                return UIColor(hex: 0xfefefe)
            case .Steel:
                return UIColor(hex: 0xfefefe)
            case .YellowBlue:
                return UIColor(hex: 0xfefefe)
            default:
                return .label
            }
        }
    }


    // MARK: Input Area

    static var inputBackground: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xfefefe)
            case .Blue:
                return UIColor(hex: 0x171c26)
            case .Gray:
                return UIColor(hex: 0x222426)
            case .Steel:
                return UIColor(hex: 0x1e2226)
            case .YellowBlue:
                return UIColor(hex: 0x171c26)
            case .Black:
                return .systemBackground
            default:
                return .secondarySystemBackground
            }
        }
    }

    static var inputForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0xfefefe)
            case .Gray:
                return UIColor(hex: 0xfefefe)
            case .Steel:
                return UIColor(hex: 0xfefefe)
            case .YellowBlue:
                return UIColor(hex: 0xfefefe)
            default:
                return .label
            }
        }
    }

    static var inputSecondaryForeground: UIColor {
        return UIColor { _ in
            switch Settings.shared.theme {
            case .Blue:
                return UIColor(hex: 0x7a8998)
            case .Gray:
                return UIColor(hex: 0x899099)
            case .Steel:
                return UIColor(hex: 0xb7c1cb)
            case .YellowBlue:
                return UIColor(hex: 0xa1b8cb)
            default:
                return .secondaryLabel
            }
        }
    }

    static var inputSeparator: UIColor {
        return UIColor { traits in
            switch Self.effectiveTheme(traits) {
            case .Light:
                return UIColor(hex: 0xd9d9da)
            case .Blue:
                return UIColor(hex: 0x36435a)
            case .Gray:
                return UIColor(hex: 0x45484c)
            case .Steel:
                return UIColor(hex: 0x3d444c)
            case .YellowBlue:
                return UIColor(hex: 0x2e384d)
            default:
                return .opaqueSeparator
            }
        }
    }
}


// MARK: - UIColor Extensions for Themes

extension UIColor {
    convenience init(hex: Int) {
        let r = CGFloat((hex >> 16) & 0xff) / 255.0
        let g = CGFloat((hex >>  8) & 0xff) / 255.0
        let b = CGFloat((hex >>  0) & 0xff) / 255.0
        self.init(displayP3Red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { context in
            self.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

//  Settings.swift - Application Settings in User Preferences

import Foundation
import UIKit

enum Theme: String, Codable, ItemPickable {
    case System     = "ThemeSystem"
    case Light      = "ThemeLight"
    case Dark       = "ThemeDark"
    case Blue       = "ThemeBlue"
    case Gray       = "ThemeGray"
    case Steel      = "ThemeSteel"
    case Black      = "ThemeBlack"
    case YellowBlue = "ThemeYellowBlue"
}

extension Theme {
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .System:     return .default
        case .Light:      return .darkContent
        case .Dark:       return .lightContent
        case .Blue:       return .lightContent
        case .Gray:       return .lightContent
        case .Steel:      return .lightContent
        case .Black:      return .lightContent
        case .YellowBlue: return .lightContent
        }
    }

    var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .System:     return .unspecified
        case .Light:      return .light
        case .Dark:       return .dark
        case .Blue:       return .unspecified
        case .Gray:       return .unspecified
        case .Steel:      return .unspecified
        case .Black:      return .dark
        case .YellowBlue: return .unspecified
        }
    }
}

enum AppIcon: String, Codable, ItemPickable {
    case IconGreen  = "AppIconGreen"
    case IconBlue   = "AppIconBlue"
    case IconRed    = "AppIconRed"
    case IconYellow = "AppIconYellow"
    case IconWhite  = "AppIconWhite"
    case IconBlack  = "AppIconBlack"
}

extension AppIcon {
    static let defaultIcon: AppIcon = .IconGreen

    static var current: Self {
        guard let id = UIApplication.shared.alternateIconName, let icon = AppIcon(rawValue: id) else { return Self.defaultIcon }
        return icon
    }

    var alternateIconId: String? {
        guard self != Self.defaultIcon else { return nil }
        return self.rawValue
    }

    var previewImage: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

enum DisplayScheme: String, Codable, ItemPickable {
    case Modern       = "DisplaySchemeModern"
    case ClassicPlato = "DisplaySchemeOldPlato"
    case ClassicSG    = "DisplaySchemeOldSG"
}

enum RefractometerFormula: String, Codable, ItemPickable {
    case Standard         = "FormulaStandard"
    case NovotnyLinear    = "FormulaNovotnyLinear"
    case NovotnyQuadratic = "FormulaNovotnyQuadratic"
    case TerrillLinear    = "FormulaTerrillLinear"
    case TerrillCubic     = "FormulaTerrillCubic"
}

final class Settings {
    static let updateNotification = Notification.Name(rawValue: "SettingsUpdated")

    static let shared = Settings()

    @Setting(defaultValue: .System)
    var theme: Theme

    @Setting(defaultValue: .Modern, notification: Settings.updateNotification)
    var displayScheme: DisplayScheme

    @Setting(defaultValue: .NovotnyLinear, notification: Settings.updateNotification)
    var formula: RefractometerFormula

    @Setting(key: "WortCorrection", defaultValue: 1.030, notification: Settings.updateNotification)
    var wortCorrection: Double

    @Setting(key: "InitialRefraction", defaultValue: 12.5, notification: Settings.updateNotification)
    var initialRefraction: Double

    @Setting(key: "FinalRefraction", defaultValue: 6.4, notification: Settings.updateNotification)
    var finalRefraction: Double

    @Setting(key: "FirstLaunch", defaultValue: true)
    var isFirstLaunch: Bool
}

@propertyWrapper
struct Setting<T> where T: Codable {
    let key: String
    let defaultValue: T
    let notification: Notification.Name?

    init(key :String? = nil, defaultValue: T, notification: Notification.Name? = nil) {
        self.key = key ?? String(describing: T.self)
        self.defaultValue = defaultValue
        self.notification = notification
    }

    var wrappedValue: T {
        get { getValue() }
        set { setValue(newValue) }
    }

    private func getValue() -> T {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return defaultValue }
        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            return defaultValue
        }
    }

    private func setValue(_ newValue: T) {
        do {
            let data = try JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
            triggerUpdate()
        } catch {
            fatalError("Encoding-error in UserDefault: \(error)")
        }
    }

    private func triggerUpdate() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(Notification(name: Settings.updateNotification))
        }
    }
}

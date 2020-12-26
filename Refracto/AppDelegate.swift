//  AppDelegate.swift

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        return delegate
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        transitionOldPreferences()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


// MARK: - Haptic Feedback

fileprivate var generator: UIImpactFeedbackGenerator? = nil

extension AppDelegate {
    func generateHapticTick() {
        guard UIDevice.current.userInterfaceIdiom == .phone else { return }
        if generator == nil {
            generator = UIImpactFeedbackGenerator()
        }
        generator?.impactOccurred(intensity: 0.18)
    }
}


// MARK: - Porting Old Preferences

extension AppDelegate {
    private func remove(key: String) {
        guard let _ = UserDefaults.standard.object(forKey: key) else { return }
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    private func extractAndRemoveValue<T>(forKey key: String) -> T? {
        guard let v = UserDefaults.standard.object(forKey: key) as? T else { return nil }
        UserDefaults.standard.removeObject(forKey: key)
        if UserDefaults.standard.synchronize() {
            return v
        } else {
            return nil
        }
    }

    private func transitionOldPreferences() {
        guard Settings.shared.isFirstLaunch else { return }

        remove(key: "displayUnit")
        remove(key: "darkInterface")

        if let v: Bool = extractAndRemoveValue(forKey: "firstLaunch") {
            Settings.shared.isFirstLaunch = v
        }
        if let v: Double = extractAndRemoveValue(forKey: "inputBeforeRefraction") {
            Settings.shared.initialRefraction = v
        }
        if let v: Double = extractAndRemoveValue(forKey: "inputCurrentRefraction") {
            Settings.shared.finalRefraction = v
        }
        if let v: Double = extractAndRemoveValue(forKey: "wortCorrectionDivisor") {
            Settings.shared.wortCorrection = v
        }
        if let v: Double = extractAndRemoveValue(forKey: "specificGravityMode") {
            switch v {
            case 1: Settings.shared.formula = .Standard
            case 2: Settings.shared.formula = .TerrillLinear
            case 3: Settings.shared.formula = .TerrillCubic
            default: break
            }
        }
    }
}

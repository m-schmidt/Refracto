//  SceneDelegate.swift

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            window.rootViewController = rootViewController()
            window.overrideUserInterfaceStyle = Settings.shared.theme.overrideUserInterfaceStyle
            window.makeKeyAndVisible()
        }
    }

    private func rootViewController() -> UITabBarController {
        let refractometer = RefractometerController()
        refractometer.tabBarItem = UITabBarItem(title: "Refracto".localized, image: UIImage(named: "Refracto"), tag: 0)

        let settings = RefractometerNavigationController(rootViewController: SettingsController(style: .insetGrouped))
        settings.view.backgroundColor = Colors.settingsBackground
        settings.navigationBar.backgroundColor = Colors.settingsBackground
        settings.tabBarItem = UITabBarItem(title: "Settings".localized, image: UIImage(named: "Settings"), tag: 1)

        let root = UITabBarController()
        root.view.tintColor = Colors.accent
        root.viewControllers = [refractometer, settings]
        root.tabBar.barTintColor = Colors.barBackground
        if let color = Colors.barShadowColor() {
            root.tabBar.backgroundImage = UIImage()
            root.tabBar.shadowImage = color.image()
        }
        root.tabBar.isTranslucent = false
        root.tabBar.unselectedItemTintColor = Colors.barSecondaryForeground

        // See also [https://developer.apple.com/forums/thread/682420]
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Colors.barBackground
            root.tabBar.standardAppearance = appearance
            root.tabBar.scrollEdgeAppearance = appearance
        }

        return root
    }
}


// - MARK: Theme Switching

extension SceneDelegate {
    func setup(theme: Theme, continuation: @escaping (PickerActionState) -> Void) {
        guard let window = window else { continuation(.abort); return }
        let overlay = window.screen.snapshotView(afterScreenUpdates: false)

        Settings.shared.theme = theme

        let root = rootViewController()
        window.overrideUserInterfaceStyle = theme.overrideUserInterfaceStyle
        window.rootViewController = root
        root.selectedIndex = 1

        let navigation = root.viewControllers!.last as! UINavigationController
        let settings = navigation.topViewController as! SettingsController
        settings.tableView(settings.tableView, didSelectRowAt: IndexPath(row: SettingsRow.Theme.rawValue, section: Section.Settings.rawValue))

        window.addSubview(overlay)
        UIView.animate(withDuration: 0.3, delay: 0.05, options: .curveEaseInOut, animations: { overlay.alpha = 0 }) { _ in
            overlay.removeFromSuperview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                navigation.popViewController(animated: true)
            }
        }
    }
}

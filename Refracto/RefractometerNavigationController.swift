//  RefractometerNavigationController.swift - Toplevel Controller of 'Settings' Tab

import UIKit

class RefractometerNavigationController : UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.barForeground]
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.barForeground]
        navigationBar.barTintColor = Colors.barBackground
        navigationBar.isTranslucent = false

        if let color = Colors.barShadowColor() {
            navigationBar.shadowImage = color.image()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return Settings.shared.theme.statusBarStyle
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

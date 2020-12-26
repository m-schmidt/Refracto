//  UIViewController+Scene.swift - Accessing the Current UIScene

import UIKit

extension UIResponder {
    @objc var scene: UIScene? {
        return nil
    }
}

extension UIScene {
    @objc override var scene: UIScene? {
        return self
    }
}

extension UIView {
    @objc override var scene: UIScene? {
        if let window = self.window {
            return window.windowScene
        } else {
            return self.next?.scene
        }
    }
}

extension UIViewController {
    @objc override var scene: UIScene? {
        var res = self.next?.scene
        if (res == nil) {
            res = self.parent?.scene
        }
        if (res == nil) {
            res = self.presentingViewController?.scene
        }
        return res
    }
}

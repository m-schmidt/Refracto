//  LinkCell.swift - Cell for Links and Actions

import UIKit

class LinkCell: SettingsBaseTableViewCell {
    static let identifier = "LinkCell"

    func configure(title: String, enabled: Bool, isLink: Bool) {
        if let textLabel = textLabel {
            textLabel.text = title
            textLabel.textColor = enabled ? Colors.accent : Colors.settingsCellDiabledForeground
        }

        var traits: UIAccessibilityTraits = []
        traits = traits.union(enabled ? [] : [.notEnabled])
        traits = traits.union(isLink ? [.link] : [.button])
        accessibilityTraits = traits
        isAccessibilityElement = true
    }
}

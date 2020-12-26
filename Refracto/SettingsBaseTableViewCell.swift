//  SettingsBaseTableViewCell.swift - Base Class for Cells in Settings Tab

import UIKit

class SettingsBaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Colors.settingsCellBackground

        let selectedBackground = UIView()
        selectedBackground.backgroundColor = Colors.settingsCellSelectedBackground
        self.selectedBackgroundView = selectedBackground

        accessibilityTraits = .button
        isAccessibilityElement = true

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
    }
}

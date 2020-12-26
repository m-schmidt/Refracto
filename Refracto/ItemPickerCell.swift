//  ItemPickerCell.swift

import UIKit

class ItemPickerCell: SettingsBaseTableViewCell {
    static let identifier = "TestCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure<T: ItemPickable>(value: T) {
        accessoryView = DisclosureIndicator()

        if let textLabel = textLabel {
            textLabel.text = T.localizedTitleDescription
            textLabel.textColor = Colors.settingsCellForeground
        }

        if let detailTextLabel = detailTextLabel {
            detailTextLabel.text = value.localizedShortItemDescription
            detailTextLabel.textColor = Colors.settingsCellSecondaryForeground
        }
    }
}

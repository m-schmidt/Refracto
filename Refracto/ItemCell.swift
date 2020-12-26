//  ItemCell.swift

import UIKit

class ItemCell: SettingsBaseTableViewCell {
    static let identifier = "ItemCell"

    private let preview = UIImageView()
    private let label = UILabel()

    override func setup() {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 12

        preview.isUserInteractionEnabled = false
        preview.layer.cornerRadius = 8.0;
        preview.layer.masksToBounds = true;
        preview.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stack.addArrangedSubview(preview)

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.textColor = Colors.settingsCellForeground
        label.numberOfLines = 0
        stack.addArrangedSubview(label.wrapped(withInsets: .zero, horizontalHuggingPriority: .defaultLow))

        contentView.embedd(view: stack, layoutGuide: contentView.layoutMarginsGuide)
    }

    func configure<T: ItemPickable>(value: T, selected: Bool) {
        let image = value.previewImage
        preview.image = image
        preview.isHidden = (image == nil)
        label.text = value.localizedItemDescription
        accessoryType = selected ? .checkmark : .none
    }
}

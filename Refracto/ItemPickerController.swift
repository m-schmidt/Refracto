//  ItemPickerController.swift

import UIKit

enum PickerActionState {
    case update
    case dismiss
    case updateAndDismiss
    case abort
}

class ItemPickerController<T>: UITableViewController where T: ItemPickable {
    typealias Action<T> = (T, @escaping (PickerActionState) -> Void) -> Void

    private var selection: T?
    private let action: Action<T>

    init(selection: T? = nil, action: @escaping Action<T>) {
        self.selection = selection
        self.action = action
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("ItemPickerController.init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = T.localizedTitleDescription
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.backgroundColor = Colors.settingsBackground
        tableView.separatorColor = Colors.settingsCellSeparator
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identifier)
        navigationItem.largeTitleDisplayMode = .never
    }

    private func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func handleSelection(ofItem item: T) {
        if item != selection {
            action(item) { state in
                switch state {
                case .update:
                    self.selection = item
                    self.tableView.reloadSections([0], with: .none)
                case .dismiss:
                    self.dismiss()
                case .updateAndDismiss:
                    self.selection = item
                    self.tableView.reloadSections([0], with: .fade)
                    self.dismiss()
                case .abort:
                    break
                }
            }
        } else {
            dismiss()
        }
    }


    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Colors.settingsCellSecondaryForeground
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.textLabel?.textColor = Colors.settingsCellSecondaryForeground
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleSelection(ofItem: T[indexPath.row])
    }


    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return T.localizedFooterDescription
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return T.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        let item = T[indexPath.row]
        cell.configure(value: item, selected: item == self.selection)
        return cell
    }
}

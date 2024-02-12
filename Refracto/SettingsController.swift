//  SettingsController.swift - Root-Level Controller for Navigation in 'Settings' Tab

import UIKit
import MessageUI


enum Section: Int, CaseIterable {
    case Settings = 0
    case Support  = 1
    case AppStore = 2
}

enum SettingsRow: Int, CaseIterable {
    case Theme          = 0
    case Icon           = 1
    case Display        = 2
    case WortCorrection = 3
}

enum SupportRow: Int, CaseIterable {
    case Website = 0
    case Contact = 1
}


@MainActor
fileprivate func canSendMail() -> Bool {
    return MFMailComposeViewController.canSendMail()
}

@MainActor
fileprivate func supportsAlternateIcons() -> Bool {
    return UIApplication.shared.supportsAlternateIcons
}



// MARK: - SettingsController

class SettingsController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.backgroundColor = Colors.settingsBackground
        tableView.separatorColor = Colors.settingsCellSeparator
        tableView.register(ItemPickerCell.self, forCellReuseIdentifier: ItemPickerCell.identifier)
        tableView.register(WortCorrectionCell.self, forCellReuseIdentifier: WortCorrectionCell.identifier)
        tableView.register(LinkCell.self, forCellReuseIdentifier: LinkCell.identifier)
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: indexPath, animated: animated)
        }
    }

    override func viewWillLayoutSubviews() {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return }
        let leftMargin = self.view.readableContentGuide.layoutFrame.minX
        self.navigationController?.navigationBar.layoutMargins.left = leftMargin
    }
}


// MARK: - User Actions

extension SettingsController {
    func openWebsite() {
        guard let websiteURL = URLComponents(string: "http://mschmidt.me/refracto.html") else { return }
        UIApplication.shared.open(websiteURL.url!)
    }

    func rateOnAppStore() {
        guard let storeURL = URLComponents(string: "itms-apps://itunes.apple.com/app/id954981822?action=write-review") else { return }
        UIApplication.shared.open(storeURL.url!)
    }

    func contactSupport() {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setToRecipients([ "refracto@mschmidt.me" ])
        vc.setSubject("MailSubject".localized)
        vc.setMessageBody("MailBody".localized, isHTML: false)
        present(vc, animated: true)
    }
}


// MARK: - MFMailComposeViewControllerDelegate

extension SettingsController : MFMailComposeViewControllerDelegate {
    nonisolated func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        Task { @MainActor in
            dismiss(animated: true) {
                if result == .failed {
                    let ok = UIAlertAction(title: "OK", style: .default)
                    let alert = UIAlertController(title: "MailFailedTitle".localized,  message: "MailFailedMessage".localized, preferredStyle: .alert)
                    alert.addAction(ok)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate

extension SettingsController {
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Colors.settingsCellSecondaryForeground
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.textLabel?.textColor = Colors.settingsCellSecondaryForeground
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section)! {
        case .Settings:
            switch SettingsRow(rawValue: indexPath.row) {
            case .Icon:
                return supportsAlternateIcons()
            case .WortCorrection:
                return false
            default:
                return true
            }
        case .Support:
            return SupportRow(rawValue: indexPath.row) != .Contact || canSendMail()
        case .AppStore:
            return true
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .Settings:
            let controller: UIViewController
            switch SettingsRow(rawValue: indexPath.row)! {
            case .Theme:
                controller = ItemPickerController<Theme>(selection: Settings.shared.theme) { theme, continuation in
                    if let sceneDelegate = self.scene?.delegate as? SceneDelegate {
                        sceneDelegate.setup(theme: theme, continuation: continuation)
                    } else {
                        continuation(.abort)
                    }
                }
            case .Icon:
                controller = ItemPickerController<AppIcon>(selection: AppIcon.current, allowReselection: true) { icon, continuation in
                    UIApplication.shared.setAlternateIconName(icon.alternateIconId) { error in
                        continuation(error == nil ? .updateAndDismiss : .abort)
                    }
                    if let cell = tableView.cellForRow(at: indexPath) as? ItemPickerCell {
                        cell.configure(value: AppIcon.current)
                    }
                }
            case .Display:
                controller = ItemPickerController<DisplayScheme>(selection: Settings.shared.displayScheme) { scheme, continuation in
                    Settings.shared.displayScheme = scheme
                    if let cell = tableView.cellForRow(at: indexPath) as? ItemPickerCell {
                        cell.configure(value: Settings.shared.displayScheme)
                    }
                    continuation(.updateAndDismiss)
                }
            case .WortCorrection:
                fatalError("WortCorrection row was selected")
            }
            self.navigationController?.pushViewController(controller, animated: true)

        case .Support:
            self.tableView?.deselectRow(at: indexPath, animated: true)
            switch SupportRow(rawValue: indexPath.row) {
            case .Website:
                openWebsite()
            case .Contact:
                contactSupport()
            default:
                break
            }

        case .AppStore:
            self.tableView?.deselectRow(at: indexPath, animated: true)
            rateOnAppStore()
        }
    }
}


// MARK: - UITableViewDataSource

extension SettingsController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .Settings:
            return "HeaderSettings".localized
        case .Support:
            return "HeaderSupport".localized
        case .AppStore:
            return "HeaderStore".localized
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .Settings:
            return "FooterSettings".localized
        case .Support:
            return canSendMail() ? nil : "FooterSupportNoMail".localized
        case .AppStore:
            return "FooterStore".localized
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Settings:
            return SettingsRow.allCases.count
        case .Support:
            return SupportRow.allCases.count
        case .AppStore:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .Settings:
            switch SettingsRow(rawValue: indexPath.row) {
                case .Theme:
                    return pickerCell(forRowAt: indexPath, content: Settings.shared.theme)
                case .Icon:
                    return pickerCell(forRowAt: indexPath, content: AppIcon.current, enabled: supportsAlternateIcons())
                case .Display:
                    return pickerCell(forRowAt: indexPath, content: Settings.shared.displayScheme)
                case .WortCorrection:
                    return wortCorrectionCell(forRowAt: indexPath)
                default:
                    fatalError("Illegal row \(indexPath.row) for Settings section requested")
            }

        case .Support:
            switch SupportRow(rawValue: indexPath.row) {
            case .Website:
                return linkCell(forRowAt: indexPath, title: "WebsiteTitle".localized)
            case .Contact:
                return linkCell(forRowAt: indexPath, title: "ContactTitle".localized, enabled: canSendMail(), isLink: false)
            default:
                fatalError("Illegal row \(indexPath.row) for Support section requested")
            }

        case .AppStore:
            guard indexPath.row == 0 else { fatalError() }
            return linkCell(forRowAt: indexPath, title: "RateAppTitle".localized)
        }
    }

    fileprivate func pickerCell<T: ItemPickable>(forRowAt indexPath: IndexPath, content: T, enabled: Bool = true) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ItemPickerCell.identifier, for: indexPath) as! ItemPickerCell
        cell.configure(value: content, enabled: enabled)
        return cell
    }

    fileprivate func wortCorrectionCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: WortCorrectionCell.identifier, for: indexPath) as! WortCorrectionCell
        cell.configure()
        return cell
    }

    fileprivate func linkCell(forRowAt indexPath: IndexPath, title: String, enabled: Bool = true, isLink: Bool = true) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: LinkCell.identifier, for: indexPath) as! LinkCell
        cell.configure(title: title, enabled: enabled, isLink: isLink)
        return cell
    }
}

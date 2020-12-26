//  ItemPickable.swift

import UIKit

protocol ItemPickable: Equatable, CaseIterable, RawRepresentable where RawValue: Localizable, Self.AllCases.Index: SignedInteger {
    static subscript(index: Int) -> Self { get }

    static var localizedTitleDescription: String { get }
    static var localizedFooterDescription: String? { get }

    var localizedItemDescription: String { get }
    var localizedShortItemDescription: String { get }
    var previewImage: UIImage? { get }
    var caseIndex: Int { get }
}


// MARK: - Default Implementation

extension ItemPickable {
    static subscript(index: Int) -> Self {
        get {
            let all = Self.allCases as! [Self]
            guard all.indices.contains(index) else { fatalError() }
            return all[ index ]
        }
    }

    static var localizedTitleDescription: String {
        let key = String(describing: self) + "Title"
        return key.localized
    }

    static var localizedFooterDescription: String? {
        let key = String(describing: self) + "Footer"
        let localized = key.localized
        return key != localized ? localized : nil
    }

    var localizedItemDescription: String {
        self.rawValue.localized
    }

    var localizedShortItemDescription: String {
        let key = String(describing: self.rawValue) + "Short"
        let shortDescription = key.localized

        if key != shortDescription {
            return shortDescription
        } else {
            return localizedItemDescription
        }
    }

    var previewImage: UIImage? {
        return nil
    }

    var caseIndex: Int {
        return Self.allCases.firstIndex(of: self) as! Int
    }
}

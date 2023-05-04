//
//  FormItem.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import Foundation

enum FormSection: Int, CaseIterable {
    case main = 0
    case add = 1

    func numberOfItems(kind: FormViewControllerKind) -> Int {
        FormItem.items(forKind: kind, section: self).count
    }
}

enum FormItem: String, CaseIterable {
    case title
    case content
    case cookStyle = "Cook Style"
    case place = "Place"
    case favoritePlace = "Favorite Place"
    case libraryAccess = "Add Pictures From Library"
    case rate = "Rate"
    case addButton

    // MARK: - Reuse Identifier

    var reuseId: String {
        return "\(rawValue)_reuseIdentifier"
    }

    func placeHolder(forKind kind: FormViewControllerKind) -> String {
        switch kind {
        case .addReview:
            switch self {
            case .title:            return "Title"
            case .content:          return "Content"
            case .addButton:        return "Add Review"
            default:                return rawValue
            }
        case .addPlace:
            switch self {
            case .title:            return "Name"
            case .content:          return "Description"
            case .addButton:        return "Add Place"
            default:                return rawValue
            }
        }
    }

    func indexPath(kind: FormViewControllerKind) -> IndexPath {
        IndexPath(row: row(kind: kind), section: section().rawValue)
    }

    static func items(forKind kind: FormViewControllerKind, section: FormSection) -> [FormItem] {
        switch kind {
        case .addReview:
            return section == .main ? [.title, .content, .place, .rate, .libraryAccess] : [.addButton]
        case .addPlace:
            return section == .main
            ? [.title, .content, .cookStyle, .favoritePlace, .libraryAccess]
            : [.addButton]
        }
    }

    private func section() -> FormSection {
        self != .addButton ? .main : .add
    }

    private func row(kind: FormViewControllerKind) -> Int {
        let items = Self.items(forKind: kind, section: section())
        return items.enumerated().first(where: { $0.element == self })?.offset ?? -1
    }

}

//
//  HomeSection.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import Foundation

enum HomeSection: Int, Hashable {
    case grid
    case list
    
    var columnCount: Int {
        switch self {
        case .list:
            return 1
        case .grid:
            return 2
        }
    }

    var title: String {
        switch self {
        case .grid:     return "Last Reviews"
        case .list:     return "Last Places"
        }
    }
}

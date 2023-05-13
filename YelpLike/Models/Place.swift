//
//  Place.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import Foundation

class Place: Identifiable {

    init(
        name: String,
        cookStyle: CookStyle,
        description: String,
        isFavorite: Bool = false,
        coordinates: String? = nil,
        imagePaths: [String]
    ) {
        self.name = name
        self.cookStyle = cookStyle
        self.description = description
        self.isFavorite = isFavorite
        self.coordinates = coordinates
        self.imagePaths = imagePaths
    }

    let id = UUID()

    var name: String
    var cookStyle: CookStyle
    var description: String
    var isFavorite: Bool = false

    var coordinates: String?
    var imagePaths: [String]

    static var all: [Place] = []

    var numberOfReviews: Int {
        Review.all.filter({ $0.placeId == id }).count
    }

}

extension Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }

}

enum CookStyle: String, CaseIterable {
    case french = "French"
    case fineDining = "Fine Dining"
    case indian = "Indian"
    case asian = "Asian"
    case fastfood = "Fast Food"
    case diet = "Diet"
    case italian = "Italian"
    case canadian = "Canadian"
    case oriental = "Oriental"
    case libanese = "Libanese"
    case healthy = "Healthy"
    case vegetarian = "Vegetarian"
}

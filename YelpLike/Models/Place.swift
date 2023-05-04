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
        imagePath: String
    ) {
        self.name = name
        self.cookStyle = cookStyle
        self.description = description
        self.isFavorite = isFavorite
        self.coordinates = coordinates
        self.imagePath = imagePath
    }

    let id = UUID()

    var name: String
    var cookStyle: CookStyle
    var description: String
    var isFavorite: Bool = false

    var coordinates: String?
    var imagePath: String

    static var all: [Place] = getDefaultData() {
        didSet {
            debugPrint("All Places: ", all)
        }
    }

    var numberOfReviews: Int {
        Review.all.filter({ $0.placeId == id }).count
    }

    private static func getDefaultData() -> [Place] {
        [
            .init(
                name: "Tutiac, Le Bistro des Vignerons",
                cookStyle: .french,
                description: "Notre jeune chef s’inspire des classiques de la gastronomie du Sud-ouest et y apporte sa créativité. Ici on défend le goût et les producteurs de nos régions.",
                imagePath: "tutiac"
            ),
            .init(
                name: "Maison Nouvelle",
                cookStyle: .fineDining,
                description: "Bienvenue chez Etxe Beste (maison nouvelle en basque) !",
                imagePath: "maison-nouvelle"
            ),
            .init(
                name: "Le Quatrieme Mur",
                cookStyle: .fineDining,
                description: "Installé dans le Grand Théâtre de Bordeaux, ce restaurant sert une cuisine de saison raffinée dans un cadre élégant et lumineux.",
                imagePath: "quatrieme-mur"
            ),
            .init(
                name: "Daily-D",
                cookStyle: .fastfood,
                description: "Sandwicherie préférée de Yannick Nay",
                imagePath: "daily-d"
            )
        ]
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

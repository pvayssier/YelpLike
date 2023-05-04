//
//  Review.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//
import Foundation

struct Review: Identifiable {
    let id = UUID()

    let placeId: UUID
    var title: String
    var content: String
    var imagePaths: [String]

    var rate: Int

    static var all: [Self] = getDefaultData() {
        didSet {
            debugPrint("All Reviews", all)
        }
    }

    private static func getDefaultData() -> [Self] {
        [
            .init(placeId: UUID(), title: "Delicious", content: "Very Good", imagePaths: [], rate: 3),
            .init(placeId: UUID(), title: "Bad", content: "Very Bad", imagePaths: [], rate: 3),
            .init(placeId: UUID(), title: "Terrible", content: "It was terrible", imagePaths: [], rate: 3),
            .init(placeId: UUID(), title: "Wonderful", content: "Incredible, Wonderful", imagePaths: [], rate: 3)
        ]
    }
}

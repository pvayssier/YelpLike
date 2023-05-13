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

    var name: String

    static var all: [Self] = []
}

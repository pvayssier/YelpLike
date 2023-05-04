//
//  HomeItem.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

struct HomeItem: Hashable, Identifiable {
    let id = UUID()

    let title: String
    let subtitle: String?
    let imagePath: String?
}

//
//  FavoritesViewModel.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import Foundation


final class FavoritesViewModel {

    init() {

    }

    // MARK: - Exposed Properties

    var onReload: ((Bool) -> Void)?

    private(set) lazy var favItems: [Place] = Place.all.filter(\.isFavorite) {
        willSet {
            onReload?(!newValue.isEmpty)
        }
    }

    // MARK: - Exposed Methods

    func viewDidAppear() {
        updateFavorites()
    }

    func didSwipeTrailing(row: Int) {
        let favItem = favItems[row]
        setFavoritePlace(favItem, to: false)
    }

    // MARK: - Private Properties

    // MARK: - Private Methods

    private func setFavoritePlace(_ favorite: Place, to value: Bool) {
        Place.all.first(where: { $0.id == favorite.id })?.isFavorite = value

        updateFavorites()
    }

    private func updateFavorites() {
        favItems = Place.all.filter(\.isFavorite)
    }

}

//
//  HomeCollectionViewDataSource.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class HomeCollectionViewDataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem> {
    
    var lastReviews: [Review] { Review.all }

    var lastPlaces: [Place] { Place.all }


    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard let section = HomeSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }

        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HomeSectionHeaderCell.reuseIdentifier,
            for: indexPath) as? HomeSectionHeaderCell

        cell?.configure(title: section.title)
        return cell ?? UICollectionReusableView()
    }


    func applySnapchotIfNeeded(animated: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()

        snapshot.appendSections([.grid, .list])

        if !lastReviews.isEmpty {
            snapshot.appendItems(
                lastReviews.map{
                    HomeItem(
                        title: $0.title,
                        subtitle: $0.content,
                        imagePath: $0.imagePaths.first)
                },
                toSection: .grid
            )
        }

        if !lastPlaces.isEmpty {
            snapshot.appendItems(
                lastPlaces.map{
                    HomeItem(
                        title: $0.name,
                        subtitle: "\($0.numberOfReviews) reviews",
                        imagePath: $0.imagePath
                    )
                },
                toSection: .list
            )
        }


    
        apply(snapshot, animatingDifferences: animated)
    }
}

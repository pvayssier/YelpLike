//
//  HomeViewController+CollectionViewLayout.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class HomeCollectionViewCompositionalLayout: UICollectionViewCompositionalLayout {

    init() {
        super.init { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            Self.makeLayout(
                sectionIndex: sectionIndex,
                layoutEnvironment: layoutEnvironment
            )
        }

        let layoutConf = UICollectionViewCompositionalLayoutConfiguration()
        layoutConf.interSectionSpacing = 30
        layoutConf.scrollDirection = .vertical

        configuration = layoutConf

        register(
            RoundedBackgroundView.self,
            forDecorationViewOfKind: RoundedBackgroundView.reuseIdentifier
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static var listConfiguration: UICollectionLayoutListConfiguration = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.separatorConfiguration = .init(listAppearance: .insetGrouped)
        config.showsSeparators = true
        config.backgroundColor = .clear

        return config
    }()


    static func makeLayout(
        sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        
        guard let section = HomeSection(rawValue: sectionIndex) else {
            return nil
        }

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        var groupHeight: NSCollectionLayoutDimension {
            switch section {
            case .grid:
                return .estimated(250)
            case .list:
                return .fractionalHeight(1.0)
            }
        }

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(250),
            heightDimension: groupHeight
        )

        var group: NSCollectionLayoutGroup {
            switch section {
            case .grid:
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )

                group.interItemSpacing = .flexible(20)

                return group
            case .list:
                return .vertical(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: section.columnCount
                )
            }
        }

        var layoutSection: NSCollectionLayoutSection {
            switch section {
            case .grid:
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 20
                section.contentInsets = .init(top: 15, leading: 20, bottom: 0, trailing: 20)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary


                let headerFooterSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                )

                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: HomeSectionHeaderCell.reuseIdentifier,
                    alignment: .topLeading
                )

                section.boundarySupplementaryItems = [sectionHeader]

                return section
            case .list:
                let section = NSCollectionLayoutSection.list(
                    using: listConfiguration,
                    layoutEnvironment: layoutEnvironment
                )


                let headerFooterSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44)
                )

                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: HomeSectionHeaderCell.reuseIdentifier,
                    alignment: .topLeading
                )

                section.boundarySupplementaryItems = [sectionHeader]

                return section
            }
        }



        return layoutSection
    }
}

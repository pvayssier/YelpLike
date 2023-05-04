//
//  HomeListCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class HomeListCell: UICollectionViewListCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        ImageManager.shared.cancelPendingRequest()
    }


    private let maximumSize = CGSize(width: 50, height: 50)

    private lazy var config: UIListContentConfiguration = {
        var contentConfiguration = UIListContentConfiguration.subtitleCell()
        contentConfiguration.imageProperties.maximumSize = maximumSize
        contentConfiguration.textProperties.font = .systemFont(ofSize: 16)
        contentConfiguration.secondaryTextProperties.color = .secondaryLabel
        contentConfiguration.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)

        return contentConfiguration
    }()

    private func configureUI() {
        backgroundConfiguration = .listGroupedCell()
        accessories = [.disclosureIndicator()]
    }

    private var imagePath: String? {
        didSet {
            fetchUserLibraryImage(imagePath: imagePath)
        }
    }

    private func fetchUserLibraryImage(imagePath: String?) {
        guard let imagePath else { return }

        ImageManager.shared.fetchImage(from: imagePath, size: maximumSize) { [weak self] image in
            self?.config.image = image
            self?.contentConfiguration = self?.config
        }
    }

    func configure(with item: HomeItem) {
        imagePath = item.imagePath
        config.image = UIImage(named: item.imagePath ?? "") ?? ImageManager.shared.defaultImage
        config.text = item.title
        config.secondaryText = item.subtitle
        contentConfiguration = config
    }

    
}

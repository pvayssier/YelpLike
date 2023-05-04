//
//  FavoritesViewControllerCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class FavoritesViewControllerCell: UITableViewCell {

    static let reuseIdentifier = String(describing: FavoritesViewControllerCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var configuration: UIListContentConfiguration = {
        var conf = defaultContentConfiguration()
        conf.image = UIImage(systemName: "photo.on.rectangle.angled")
        conf.imageProperties.maximumSize = CGSize(width: 80, height: 80)
        conf.imageProperties.tintColor = .tintColor
        conf.imageProperties.cornerRadius = 9

        conf.text = "No Data"

        return conf
    }()

    private func configureUI() {
        contentConfiguration = configuration
    }

    func configure(title: String, image: UIImage?) {
        configuration.text = title
        if let image { configuration.image = image }
        contentConfiguration = configuration
    }
}

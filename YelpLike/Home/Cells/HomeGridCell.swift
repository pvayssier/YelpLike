//
//  HomeGridCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit


final class HomeGridCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static let reuseId = String(describing: HomeGridCell.self)

    static let cellSize = CGSize(width: 250, height: 250)

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self else { return }
                self.contentView.alpha = self.isHighlighted ? 0.8 : 1
            }
        }
    }

    private var imagePath: String? {
        didSet {
            fetchUserLibraryImage(imagePath: imagePath)
        }
    }

    private func fetchUserLibraryImage(imagePath: String?) {
        guard let imagePath, let scale = contentView.window?.screen.scale else { return }

        let upscaledSize = CGSize(
            width: Self.cellSize.width * scale,
            height: Self.cellSize.height * scale
        )

        ImageManager.shared.fetchImage(from: imagePath, size: upscaledSize) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .left

        return label
    }()

    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: UIFont.smallSystemFontSize, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()

    private func configureUI() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(secondaryLabel)

        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.78),

            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),

            secondaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            secondaryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            secondaryLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with item: HomeItem) {
        imagePath = item.imagePath
        titleLabel.text = item.title
        secondaryLabel.text = item.subtitle
        guard let image = item.imagePath else {
            let image = ImageManager.shared.defaultImage
            imageView.image = image
            return
        }
        imageView.image = UIImage(named: image)
    }
}


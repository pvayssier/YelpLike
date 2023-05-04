//
//  FormRateCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class FormRateCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: UIFont.labelFontSize)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()

        return label
    }()

    private lazy var ratingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually

        stackView.sizeToFit()

        return stackView
    }()

    private func makeStarButton(at index: Int, tinted: Bool) -> RateButton {
        let button = RateButton(icon: UIImage(systemName: "star.fill"), ratingIndex: index)
        button.isTinted = tinted
        button.addTarget(self, action: #selector(didTapRateButton(sender:)), for: .touchUpInside)

        return button
    }

    private func configureUI() {
        selectionStyle = .none

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingView)

        setRatingButtons()

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor),

            ratingView.widthAnchor.constraint(equalToConstant: 130),
            ratingView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            ratingView.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor),
            ratingView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
        ])
    }

    private func setRatingButtons() {
        if !ratingView.arrangedSubviews.isEmpty {
            ratingView.arrangedSubviews.forEach { view in
                view.removeFromSuperview()
            }
        }

        (1...maxRate).forEach { index in
            ratingView.addArrangedSubview(makeStarButton(at: index, tinted: currentRate >= index))
        }
    }

    @objc
    private func didTapRateButton(sender: RateButton) {
        currentRate = sender.ratingIndex
    }

    // MARK: Exposed

    private(set) lazy var maxRate = 5

    private(set) var currentRate = 3 {
        didSet {
            setRatingButtons()
        }
    }

    func configure(title: String, currentRate: Int) {
        titleLabel.text = title
        self.currentRate = currentRate
    }
}


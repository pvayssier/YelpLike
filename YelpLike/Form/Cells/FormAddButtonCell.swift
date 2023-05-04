//
//  FormAddButtonCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//
import UIKit

final class FormAddButtonCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.buttonView.transform = state.isHighlighted
            ? CGAffineTransform(scaleX: 0.96, y: 0.96)
            : .identity
        }
    }

    // MARK: - Private

    private lazy var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .tintColor
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.sizeToFit()

        return label
    }()

    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none

        buttonView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(buttonView)
        buttonView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            buttonView.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            titleLabel.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
    }

    // MARK: Exposed

    func configure(title: String) {
        titleLabel.text = title
    }
}

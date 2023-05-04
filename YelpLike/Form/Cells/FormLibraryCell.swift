//
//  FormLibraryCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class FormLibraryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private lazy var config: UIListContentConfiguration = {
        var conf = defaultContentConfiguration()
        conf.textProperties.color = .tintColor

        return conf
    }()

    private let generator: UIImpactFeedbackGenerator

    private let plusImageView = UIImageView(image: UIImage(systemName: "plus"))


    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.contentView.alpha = state.isHighlighted ? 0.6 : 1
            self.generator.impactOccurred()
        }
    }


    // MARK: Exposed

    func configure(title: String) {
        selectionStyle = .none
        config.text = title
        contentConfiguration = config
        accessoryView = plusImageView
    }

}

//
//  RateButton.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class RateButton: UIButton {
    init(icon: UIImage?, ratingIndex: Int) {
        self.ratingIndex = ratingIndex
        self.icon = icon
        super.init(frame: .zero)
        super.configuration = makeButtonConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    private(set) var ratingIndex: Int

    var isTinted: Bool = false {
        didSet {
            configuration = makeButtonConfiguration()
        }
    }

    private let icon: UIImage?

    // MARK: - Private

    private func makeButtonConfiguration() -> UIButton.Configuration {
        var btnConf = UIButton.Configuration.plain()

        var imageConf = UIImage.SymbolConfiguration(hierarchicalColor: isTinted ? .systemYellow : .systemGray3)
        imageConf = imageConf.applying(
            UIImage.SymbolConfiguration(font: .systemFont(ofSize: UIFont.smallSystemFontSize))
        )

        btnConf.image = icon?.withConfiguration(imageConf)
        btnConf.preferredSymbolConfigurationForImage = imageConf

        return btnConf
    }
}

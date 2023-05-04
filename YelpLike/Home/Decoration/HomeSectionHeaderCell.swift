//
//  HomeSectionHeader.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class HomeSectionHeaderCell: UICollectionViewListCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentConfiguration = contentConf
        backgroundConfiguration = .listGroupedHeaderFooter()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var contentConf: UIListContentConfiguration = {
        var conf = UIListContentConfiguration.prominentInsetGroupedHeader()
        conf.directionalLayoutMargins = .zero
        return conf
    }()

    func configure(title: String) {
        contentConf.text = title
        contentConfiguration = contentConf
    }

}

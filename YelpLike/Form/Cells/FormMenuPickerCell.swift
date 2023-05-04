//
//  FormMenuPickerCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//


import UIKit

final class FormMenuPickerCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private lazy var config = defaultContentConfiguration()

    private lazy var selection: [String] = []

    private lazy var menuTitle: String? = nil

    private func makeMenu() -> UIMenu {
        let actions: [UIAction] = selection.compactMap { [weak self] in
            guard let self, let selectedValue = self.selectedValue else { return nil }

            return UIAction(
                title: $0,
                state: $0 == selectedValue ? .on : .off,
                handler: { action in
                    self.selectedValue = action.title
                }
            )
        }

        let menu = UIMenu(
            title: menuTitle ?? "",
            image: UIImage(systemName: "chevron.up.and.down"),
            options: .singleSelection,
            children: actions
        )

        return menu
    }

    private func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        let font = UIFont.systemFont(ofSize: 9, weight: .medium)

        var config = UIImage.SymbolConfiguration(font: font)
        config = config.applying(UIImage.SymbolConfiguration(hierarchicalColor: .secondaryLabel))

        let image = UIImage(
            systemName: "chevron.up.chevron.down",
            withConfiguration: config)

        let attrTitle = NSAttributedString(
            string: selectedValue ?? "Choose",
            attributes: [
                .font: UIFont.systemFont(ofSize: 17),
                .foregroundColor: UIColor.secondaryLabel
            ]
        )

        var buttonConf = UIButton.Configuration.plain()
        buttonConf.attributedTitle = AttributedString(attrTitle)
        buttonConf.image = image
        buttonConf.imagePadding = 5
        buttonConf.imagePlacement = .trailing
        buttonConf.contentInsets = .zero

        button.configuration = buttonConf
        button.menu = makeMenu()
        button.showsMenuAsPrimaryAction = true
        button.sizeToFit()

        return button
    }


    // MARK: Exposed

    func configure(title: String, menuTitle: String?, selection: [String]) {
        self.selection = selection
        self.menuTitle = menuTitle
        accessoryView = makeButton()
        selectionStyle = .none
        config.text = title

        contentConfiguration = config
    }


    private (set) lazy var selectedValue: String? = selection.first {
        didSet {
            accessoryView = makeButton()
        }
    }

}

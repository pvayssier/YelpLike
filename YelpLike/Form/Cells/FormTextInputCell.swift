//
//  FormTextInputCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//
import UIKit

final class FormTextInputCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    override var isSelected: Bool {
        didSet {
            if isSelected { textField.becomeFirstResponder() }
        }
    }

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.contentVerticalAlignment = .top
        textField.textAlignment = .left
        textField.contentHorizontalAlignment = .left
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always

        return textField
    }()

    private func configureUI() {
        selectionStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
    }

    // MARK: Exposed

    func configure(placeholder: String) {
        textField.placeholder = placeholder
    }

    func getInputText() -> String? {
        return textField.text
    }

}

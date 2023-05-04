//
//  FormLargeTextInputCell.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class FormLargeTextInputCell: UITableViewCell {
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
            if isSelected {
                textView.becomeFirstResponder()
            }
        }
    }

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: UIFont.labelFontSize)
        label.textAlignment = .left
        label.baselineAdjustment = .alignBaselines
        label.sizeToFit()
        label.text = ""

        return label
    }()


    private lazy var textView: UITextView = {
        let textField = UITextView()

        textField.backgroundColor = .secondarySystemGroupedBackground
        textField.font = .systemFont(ofSize: UIFont.labelFontSize)
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        textField.layoutMargins = .zero
        textField.delegate = self

        return textField
    }()

    private func configureUI() {
        selectionStyle = .none
        textView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textView)
        textView.insertSubview(placeholderLabel, at: 100)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 7),
            placeholderLabel.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 5),
            placeholderLabel.rightAnchor.constraint(equalTo: textView.rightAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor)
        ])
    }

    // MARK: Exposed

    func configure(placeholder: String) {
        placeholderLabel.text = placeholder
    }

    func getInputText() -> String? {
        return textView.text
    }

}

extension FormLargeTextInputCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

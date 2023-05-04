//
//  LoginViewController.swift
//  YelpLike
//
//  Created by Paul Vayssier on 03/05/2023.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = .systemGroupedBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 15
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .left
        textField.contentHorizontalAlignment = .left
        textField.autocorrectionType = .no
        textField.clearButtonMode = .always

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }()


    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .systemGroupedBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 15
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .left
        textField.contentHorizontalAlignment = .left
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AccentColor")
        label.text = "Enter your password:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left

        return label
    }()

    private func configureUI() {
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordLabel)

        NSLayoutConstraint.activate([
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.widthAnchor.constraint(equalToConstant: 300),

            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),


            passwordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50),
            passwordLabel.widthAnchor.constraint(equalToConstant: 300)
        ])

        view.backgroundColor = .tertiarySystemBackground


    }


}

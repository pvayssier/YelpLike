//
//  LoginViewController.swift
//  YelpLike
//
//  Created by Paul Vayssier on 03/05/2023.
//

import UIKit
import CryptoKit

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
        textField.autocapitalizationType = .none

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
        textField.autocapitalizationType = .none
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

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AccentColor")
        label.text = "Enter your username:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left

        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.8)
        label.text = "Login"
        let font = UIFont(name: "Helvetica Neue Bold", size: 50)
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica Neue Bold", size: 25)!
        button.backgroundColor = .tintColor

        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 15

        return button
    }()

    private func configureUI() {
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordLabel)
        view.addSubview(usernameLabel)
        view.addSubview(titleLabel)
        view.addSubview(submitButton)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),

            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            usernameTextField.widthAnchor.constraint(equalToConstant: 300),

            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),

            usernameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -190),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            usernameLabel.heightAnchor.constraint(equalToConstant: 50),
            usernameLabel.widthAnchor.constraint(equalToConstant: 300),

            passwordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50),
            passwordLabel.widthAnchor.constraint(equalToConstant: 300),

            submitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.widthAnchor.constraint(equalToConstant: 300)

        ])

        submitButton.addTarget(self, action: #selector(didSubmitButtonClicked), for: .touchUpInside)

        view.backgroundColor = .tertiarySystemBackground
    }


    @objc private func didSubmitButtonClicked(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        if !username.isEmpty && !password.isEmpty {
            DatabaseService.shared.checkUserCredentials(username: username, password: hashPassword(password)) { [weak self] error in
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription, action: UIAlertAction(title: "Ok", style: .default))
                } else {
                    self?.dismiss(animated: true)
                }
            }
        } else {
            showAlert(title: "Manque d'information", message: "Il faut que vous remplissiez votre username et votre password.", action: UIAlertAction(title: "Ok", style: .default))
        }
    }

    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        return hashedString
    }

    private func showAlert(title: String, message: String, action: UIAlertAction) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(action)
        present(alertController, animated: true)
    }


}

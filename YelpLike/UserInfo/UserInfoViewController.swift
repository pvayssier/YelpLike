//
//  UserInfoViewController.swift
//  YelpLike
//
//  Created by Paul Vayssier on 12/05/2023.
//

import UIKit
import Combine

class UserInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showLoadingView()
        DatabaseService.shared.getUserReviews { [weak self] reviews in
            self?.reviews = reviews
            DatabaseService.shared.isLoading = false
        }
        setupObserver()
    }

    private var reviews: [Review]?

    // MARK: - Combine


    private var subscriptions = Set<AnyCancellable>()

    private func setupObserver() {
        DatabaseService.shared.$isLoading.sink { [weak self] isLoading in
            if !isLoading {
                self?.hideLoadingView()
                self?.configureUI()
            }
        }.store(in: &subscriptions)
    }

    // MARK: - LoaderView

    private var loaderView: UIView?

    private func showLoadingView() {
        let loaderView = UIView(frame: UIScreen.main.bounds)
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = loaderView.center
        loaderView.addSubview(activityIndicator)
        loaderView.backgroundColor = view.backgroundColor
        activityIndicator.startAnimating()
        view.addSubview(loaderView)
        self.loaderView = loaderView
    }

    private func hideLoadingView() {
        loaderView?.isHidden = true
        configureUI()
        tableView.reloadData()
    }

    private lazy var nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.8)
        label.text = (DatabaseService.shared.userInfo["username"] as! String)
        let font = UIFont(name: "Helvetica Neue Bold", size: 50)
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UserInfoViewController.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private let cellReuseIdentifier = String(describing: UserInfoViewController.self)

    private func configureUI() {
        view.addSubview(nameLabel)
        view.addSubview(tableView)
        tableView.register(UserInfoViewController.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        view.backgroundColor = .secondarySystemGroupedBackground
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 60),
            nameLabel.widthAnchor.constraint(equalToConstant: 300),

            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}


extension UserInfoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            return UITableViewCell()
        }
        let review = reviews?[indexPath.row]
        print(review)
        cell.textLabel?.text = review?.name
        guard let imageString = review?.imagePaths.first, let image = UIImage(named: imageString ) else {
            cell.imageView?.image =  UIImage(systemName: "photo.on.rectangle.angled")
            return cell
        }
        cell.imageView?.image = image
        return cell
    }
}

// MARK: - TableViewDelegate

extension UserInfoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

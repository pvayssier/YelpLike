//
//  FavoritesViewController.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class FavoritesViewController: UITableViewController {

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onReload = { [weak self] isNotEmpty in
            self?.tableView.backgroundView?.isHidden = isNotEmpty
        }


        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
        tableView.reloadData()
    }

    // MARK: - Private Properties

    private let viewModel: FavoritesViewModel


    private func deleteAction(row: Int) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _ in
            guard let self else { return }

            self.viewModel.didSwipeTrailing(row: row)
            self.tableView.reloadData()
        }

        action.image = UIImage(systemName: "star.slash.fill")
        action.backgroundColor = .systemYellow
        
        return action
    }

    // MARK: - Private Methods

    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = TabItem.favs.title

        tableView.register(
            FavoritesViewControllerCell.self,
            forCellReuseIdentifier: FavoritesViewControllerCell.reuseIdentifier
        )

        let emptyStateView = EmptyStateView(
            imageSystemName: "star.slash",
            text: "Looks like you haven't any favorites places"
        )

        tableView.backgroundView = emptyStateView.makeHostingController().view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoritesViewControllerCell.reuseIdentifier)
                as? FavoritesViewControllerCell else {
            return UITableViewCell()
        }

        let item = viewModel.favItems[indexPath.row]
        cell.configure(title: item.name, image: UIImage(named: item.imagePaths.first ?? ""))

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [deleteAction(row: indexPath.row)])
    }
}


//
//  HomeViewController.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit

final class HomeViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: HomeCollectionViewCompositionalLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        Task {
            await checkIfConnect()
        }
        super.viewDidLoad()
        configureUI()
    }

    private func checkIfConnect() async {
        let isConnect = await DatabaseService.shared.checkIfConnect()
        if !isConnect {
            present(LoginViewController(nibName: nil, bundle: nil), animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emptyStateView.isHidden = !(dataSource.lastPlaces.isEmpty && dataSource.lastReviews.isEmpty)

        dataSource.applySnapchotIfNeeded()
    }

    // MARK: - Private Properties

    private lazy var dismissAction: () -> Void = { [weak self] in
        self?.dataSource.applySnapchotIfNeeded(animated: true)
    }

    private typealias ListCellRegistration = UICollectionView.CellRegistration<HomeListCell, HomeItem>

    private typealias GridCellRegistration = UICollectionView.CellRegistration<HomeGridCell, HomeItem>

    private typealias DataSource = HomeCollectionViewDataSource

    private lazy var emptyStateView: UIView = EmptyStateView(
        imageSystemName: "plus.square.dashed",
        text: "Start by adding a place, then add reviews"
    ).makeHostingController().view


    private lazy var dataSource: DataSource = {
        return DataSource(collectionView: collectionView) { [weak self] (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            itemIdentifier: HomeItem
        ) -> UICollectionViewCell? in

            guard let self, let section = HomeSection(rawValue: indexPath.section) else { return nil }

            switch section {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.listCellRegistration,
                    for: indexPath,
                    item: itemIdentifier
                )
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.gridCellRegistration,
                    for: indexPath,
                    item: itemIdentifier
                )
            }
        }
    }()

    private let listCellRegistration = ListCellRegistration { (cell, indexPath, item) in
        cell.configure(with: item)
    }

    private let gridCellRegistration = GridCellRegistration { (cell, indexPath, item) in
        cell.configure(with: item)
    }

    private lazy var contextMenu: UIMenu = {
        let actions: [UIAction] = [
            UIAction(
                title: "Add Review",
                image: UIImage(systemName: "menucard"),
                handler: { [weak self] _ in
                    self?.presentForm(kind: .addReview)
                }
            ),
            UIAction(
                title: "Add Place",
                image: UIImage(systemName: "mappin"),
                handler: { [weak self] _ in
                    self?.presentForm(kind: .addPlace)
                }
            )
        ]
        return UIMenu(title: "", children: actions)
    }()

    // MARK: - Private Methods

    private func configureUI() {
        collectionView.backgroundColor = .systemGroupedBackground
        navigationItem.title = TabItem.home.title
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: nil,
            menu: contextMenu
        )

        configureCollectionView()

        dataSource.applySnapchotIfNeeded()
    }

    private func configureCollectionView() {
        collectionView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delaysContentTouches = false
        collectionView.dataSource = dataSource
        
        collectionView.register(
            HomeSectionHeaderCell.self,
            forSupplementaryViewOfKind: HomeSectionHeaderCell.reuseIdentifier,
            withReuseIdentifier: HomeSectionHeaderCell.reuseIdentifier
        )
    }

    private func presentForm(kind: FormViewController.Kind) {
        let formViewController = FormViewController(kind: kind)
        formViewController.onDismiss = { [weak self] in
            self?.dismissAction()
        }

        let navigationController = UINavigationController(
            rootViewController: formViewController
        )

        present(navigationController, animated: true)
    }

}


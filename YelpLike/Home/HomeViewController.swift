//
//  HomeViewController.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit
import Combine

final class HomeViewController: UICollectionViewController {

    init() {
        super.init(collectionViewLayout: HomeCollectionViewCompositionalLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        setupObservers()
        super.viewDidLoad()
        configureUI()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emptyStateView.isHidden = !(dataSource.lastPlaces.isEmpty && dataSource.lastReviews.isEmpty)
        dataSource.applySnapchotIfNeeded()
//        if let _ = DatabaseService.shared.userInfo["user_id"] {
//        } else {
//            let viewController = LoginViewController(nibName: nil, bundle: nil)
//            let navigationController = UINavigationController(rootViewController: viewController)
//            self.present(navigationController, animated: true)
//        }
    }

    // MARK: - Combine

    private var subscriptions = Set<AnyCancellable>()

    private func setupObservers() {
        DatabaseService.shared.$didHaveNetwork.sink { [weak self] didHaveNetwork in
            if !didHaveNetwork {
                self?.showAlert()
            }
        }.store(in: &subscriptions)


        DatabaseService.shared.$isConnect.sink { [weak self] val in
            let viewController = LoginViewController(nibName: nil, bundle: nil)
            let navigationController = UINavigationController(rootViewController: viewController)
            guard let self else { return }
            if !val && DatabaseService.shared.session != UserDefaults.standard.string(forKey: "sessionUUID") {
                self.present(navigationController, animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }.store(in: &subscriptions)

        DatabaseService.shared.$isLoading.sink { [weak self] isLoading in
            isLoading ? self?.showLoadingView() : self?.hideLoadingView()
        }.store(in: &subscriptions)
    }

    // MARK: - Loader view

    private var loaderView: UIView?

    private func showLoadingView() {
        let loaderView = UIView(frame: UIScreen.main.bounds)
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = loaderView.center
        loaderView.addSubview(activityIndicator)
        let tabBarHeight = tabBarController!.tabBar.frame.size.height
        view.addSubview(loaderView)
        loaderView.frame = CGRect(
            x: 0,
            y: 0,
            width: tabBarController!.view.frame.width,
            height: tabBarController!.view.frame.height - tabBarHeight)
        NSLayoutConstraint.activate([
            loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight)
            
        ])
        loaderView.backgroundColor = collectionView.backgroundColor
        activityIndicator.startAnimating()
        self.loaderView = loaderView
    }

    private func hideLoadingView() {
        loaderView?.isHidden = true
        configureUI()
        emptyStateView.isHidden = !(dataSource.lastPlaces.isEmpty && dataSource.lastReviews.isEmpty)
        dataSource.applySnapchotIfNeeded()
    }

    // MARK: - Private Properties

    private func showAlert() {
        let alertController = UIAlertController(
            title: "No Internet Connection",
            message: "Please check your internet connection and try again.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            DatabaseService.shared.hasInternetConnection()
            self?.didTapTryAgainButton()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    @objc private func didTapTryAgainButton() {
        if DatabaseService.shared.didHaveNetwork {
            self.configureUI()
            DatabaseService.shared.$isConnect.sink { [weak self] val in
                let viewController = LoginViewController(nibName: nil, bundle: nil)
                let navigationController = UINavigationController(rootViewController: viewController)
                guard let self else { return }
                if !val && DatabaseService.shared.session != "" {
                    self.present(navigationController, animated: true)
                } else {
                    self.dismiss(animated: true)
                }
            }.store(in: &subscriptions)
        }

    }

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

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.fill"),
            style: .done,
            target: self,
            action: #selector(didUserButtonClicked(sender:)))

        configureCollectionView()

        dataSource.applySnapchotIfNeeded()
    }

    @objc private func didUserButtonClicked(sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: "sessionUUID")
        DatabaseService.shared.session = "Empty"
        DatabaseService.shared.isConnect = false
//        if let user_id = DatabaseService.shared.userInfo["user_id"] {
//            self.present(UserInfoViewController(nibName: nil, bundle: nil), animated: true)
//        } else {
//            self.present(LoginViewController(nibName: nil, bundle: nil), animated: true)
//        }
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

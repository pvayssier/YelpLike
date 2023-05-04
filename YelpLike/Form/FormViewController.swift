//
//  FormViewController.swift
//  YelpLike
//
//  Created by Paul Vayssier on 28/04/2023.
//

import UIKit
import PhotosUI

enum FormViewControllerKind {
    case addReview
    case addPlace

    var title: String {
        switch self {
        case .addReview:         return "Add Review"
        case .addPlace:          return "Add Place"
        }
    }
}

final class FormViewController: UITableViewController {

    // MARK: Init

    init(kind: Kind) {
        self.kind = kind
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    // MARK: - Exposed Properties

    typealias Kind = FormViewControllerKind

    var onDismiss: (() -> Void)?

    // MARK: - Private Properties

    private let kind: Kind

    private var selectedPicturesIdentifiers: [String] = []

    // MARK: - Private Methods

    private func configureUI() {
        navigationItem.title = kind.title
        navigationController?.navigationBar.prefersLargeTitles = false

        configureTableView()
    }

    // MARK: TableView Configuration

    private func configureTableView() {
        registerCells()
        tableView.delaysContentTouches = false
        tableView.keyboardDismissMode = .onDrag
    }

    private func registerCells() {
        tableView.register(FormTextInputCell.self, forCellReuseIdentifier: FormItem.title.reuseId)
        tableView.register(FormLargeTextInputCell.self, forCellReuseIdentifier: FormItem.content.reuseId)
        tableView.register(FormToggleCell.self, forCellReuseIdentifier: FormItem.favoritePlace.reuseId)
        tableView.register(FormLibraryCell.self, forCellReuseIdentifier: FormItem.libraryAccess.reuseId)
        tableView.register(FormMenuPickerCell.self, forCellReuseIdentifier: FormItem.place.reuseId)
        tableView.register(FormRateCell.self, forCellReuseIdentifier: FormItem.rate.reuseId)
        tableView.register(FormMenuPickerCell.self, forCellReuseIdentifier: FormItem.cookStyle.reuseId)
        tableView.register(FormAddButtonCell.self, forCellReuseIdentifier: FormItem.addButton.reuseId)
    }

    private func getCell(formItem: FormItem) -> UITableViewCell?  {
        tableView.cellForRow(at: formItem.indexPath(kind: kind))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        FormSection.allCases.count
    }

    // MARK: TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let formSection = FormSection(rawValue: section) else { return 0 }
        return formSection.numberOfItems(kind: kind)
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let formSection = FormSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        let item = FormItem.items(forKind: kind, section: formSection)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseId)

        switch item {
        case .title:
            (cell as? FormTextInputCell)?.configure(placeholder: item.placeHolder(forKind: kind))
        case .content:
            (cell as? FormLargeTextInputCell)?.configure(placeholder: item.placeHolder(forKind: kind))
        case .favoritePlace:
            (cell as? FormToggleCell)?.configure(title: item.placeHolder(forKind: kind))
        case .cookStyle:
            (cell as? FormMenuPickerCell)?
                .configure(
                    title: item.placeHolder(forKind: kind),
                    menuTitle: "Cook Styles",
                    selection: CookStyle.allCases.map { $0.rawValue }
                )
        case .place:
            (cell as? FormMenuPickerCell)?
                .configure(
                    title: item.placeHolder(forKind: kind),
                    menuTitle: "Places",
                    selection: Place.all.map { $0.name }
                )
        case .rate:
            (cell as? FormRateCell)?
                .configure(title: item.placeHolder(forKind: kind), currentRate: 3)
        case .libraryAccess:
            (cell as? FormLibraryCell)?.configure(title: item.placeHolder(forKind: kind))
        case .addButton:
            (cell as? FormAddButtonCell)?.configure(title: item.placeHolder(forKind: kind))
        }

        return cell ?? UITableViewCell()
    }

    // MARK: TableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let formSection = FormSection(rawValue: indexPath.section) else {
            return .zero
        }

        let item = FormItem.items(forKind: kind, section: formSection)[indexPath.row]

        switch item {
        case .title, .addButton:
            return 45
        case .content:
            return 190

        default:
            return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = FormSection(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .main:
            if FormItem.libraryAccess.indexPath(kind: kind) == indexPath {
                presentLibrary()
            }
        case .add:
            addItem()
        }
    }
}

// MARK: - Photos Picker

extension FormViewController {
    private func presentLibrary() {
        var imagePickerConf = PHPickerConfiguration(photoLibrary: .shared())
        imagePickerConf.selectionLimit = kind == .addPlace ? 1 : 3
        imagePickerConf.filter = .all(of: [.images])
        imagePickerConf.selection = .default

        let imagePickerController = PHPickerViewController(configuration: imagePickerConf)
        imagePickerController.delegate = self
        imagePickerController.modalTransitionStyle = .coverVertical
        imagePickerController.modalPresentationStyle = .fullScreen

        present(imagePickerController, animated: true)
    }
}

extension FormViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        selectedPicturesIdentifiers = results.compactMap { $0.assetIdentifier }
        picker.dismiss(animated: true)
    }
}

// MARK: - Add Items

extension FormViewController {

    private func addItem() {
        let itemTitle = (getCell(formItem: .title) as? FormTextInputCell)?.getInputText()

        var itemContent: String? {
            switch kind {
            case .addPlace:
                return (getCell(formItem: .content) as? FormTextInputCell)?.getInputText()
            case .addReview:
                return (getCell(formItem: .content) as? FormLargeTextInputCell)?.getInputText()
            }
        }

        let placeName = (getCell(formItem: .place) as? FormMenuPickerCell)?.selectedValue
        let isFavItem = (getCell(formItem: .favoritePlace) as? FormToggleCell)?.isOn

        let cookStyle = CookStyle(
            rawValue: (getCell(formItem: .cookStyle) as? FormMenuPickerCell)?.selectedValue
            ?? CookStyle.fastfood.rawValue) ?? .fastfood

        let rate = (getCell(formItem: .rate) as? FormRateCell)?.currentRate ?? 3

        switch kind {
        case .addPlace:
            let place = Place(
                name: itemTitle ?? "",
                cookStyle: cookStyle,
                description: itemContent ?? "",
                isFavorite: isFavItem ?? false,
                imagePath: selectedPicturesIdentifiers.first ?? "daily-d"
            )

            Place.all.append(place)
        case .addReview:
            let review = Review(
                placeId: getPlace(from: placeName)?.id ?? Place.all[0].id,
                title: itemTitle ?? "",
                content: itemContent ?? "",
                imagePaths: selectedPicturesIdentifiers,
                rate: rate
            )
            Review.all.append(review)
        }

        dismiss(animated: true)
        onDismiss?()
    }

    private func getPlace(from name: String?) -> Place? {
        guard let name else { return nil }
        return Place.all.first(where: { $0.name == name })
    }
}

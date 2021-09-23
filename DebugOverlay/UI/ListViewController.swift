//
//  ListViewController.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/19/20.
//

import UIKit

final class ListViewController: UIViewController {
    private let items: [OverlayItem]

    private lazy var collectionView: UICollectionView = {
        let layout = ListFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 4

        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: layout
        )
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    var closeAction: (() -> Void)?

    init(items: [OverlayItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "Debug Menu"
        if #available(iOS 11.0, *) {
            navigationItem.backButtonTitle = ""
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let closeItem = UIBarButtonItem(
            image: UIImage.bundled(named: "close"),
            style: .done,
            target: self,
            action: #selector(closeMenu)
        )
        navigationItem.rightBarButtonItem = closeItem

        view.addSubview(collectionView)
    }

    @objc func closeMenu() {
        closeAction?()
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListCell.reuseIdentifier,
            for: indexPath
        ) as! ListCell

        let item = items[indexPath.item]
        cell.titleLabel.text = item.title
        cell.subTitleLabel.text = item.subtitle
        item.updateItem = { [weak cell] item in
            cell?.titleLabel.text = item.title
            cell?.subTitleLabel.text = item.subtitle
        }
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        switch item.action {
        case let .sublist(items):
            let sublist = ListViewController(items: items)
            sublist.title = item.title
            sublist.closeAction = closeAction
            navigationController?.pushViewController(sublist, animated: true)
        case let .action(action):
            action(item)
        case let .present(viewClosure):
            guard let view = viewClosure(item) else { return }
            navigationController?.present(view, animated: true, completion: nil)
        case let .push(viewClosure):
            guard let view = viewClosure(item) else { return }
            navigationController?.pushViewController(view, animated: true)
        }
    }
}

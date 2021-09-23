//
//  ListFlowLayout.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/19/20.
//

import UIKit

final class ListFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).size.width

        itemSize = CGSize(width: availableWidth, height: 44)
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 0, bottom: 0, right: 0)
        sectionInsetReference = .fromSafeArea
    }
}

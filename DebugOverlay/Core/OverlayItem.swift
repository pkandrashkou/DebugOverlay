//
//  OverlayItem.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 9/23/21.
//

import UIKit

public enum OverlayItemAction {
    case sublist(items: [OverlayItem])
    case action((OverlayItem) -> Void)
    case push(view: (OverlayItem) -> UIViewController?)
    case present(view: (OverlayItem) -> UIViewController?)
}

public final class OverlayItem {
    var title: String
    var subtitle: String?

    let action: OverlayItemAction

    init(title: String, subtitle: String? = nil, action: OverlayItemAction) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    var updateItem: ((OverlayItem) -> Void)?

    func setNeedsToUpdateItem() {
        updateItem?(self)
    }
}

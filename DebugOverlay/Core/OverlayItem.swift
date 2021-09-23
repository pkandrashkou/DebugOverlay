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
    public var title: String
    public var subtitle: String?

    internal let action: OverlayItemAction

    public init(title: String, subtitle: String? = nil, action: OverlayItemAction) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    internal var updateItem: ((OverlayItem) -> Void)?

    public func setNeedsToUpdateItem() {
        updateItem?(self)
    }
}

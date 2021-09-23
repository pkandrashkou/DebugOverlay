//
//  PassthroughView.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/19/20.
//

import UIKit

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self {
            return nil
        } else {
            return result
        }
    }
}

//
//  UIImage.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/19/20.
//

import UIKit

extension UIImage {
    static func bundled(named: String) -> UIImage? {
        UIImage(named: named, in: Bundle(for: DebugOverlay.self), compatibleWith: nil)
    }
}

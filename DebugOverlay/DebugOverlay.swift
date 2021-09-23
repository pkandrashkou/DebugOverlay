//
//  DebugOverlay.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/17/20.
//

import UIKit

public final class DebugOverlay {
    public static let shared: DebugOverlay = .init()
    private var window: OverlayWindow!
    private var overlay: OverlayViewController!

    private init() { }

    public func inject(configuration: OverlayConfiguration) {
        let window = OverlayWindow(frame: UIScreen.main.bounds)
        let overlay = OverlayViewController(configuration: configuration)
        window.rootViewController = overlay
        window.delegate = overlay
        window.isHidden = false

        StatusBarHandler.shared.onTriggerAction = { [weak overlay] in
            overlay?.toggleDebugMenu()
        }

        self.overlay = overlay
        self.window = window
    }
}

//
//  Bundle.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 12/18/20.
//

import Foundation

extension Bundle {
    static var marketingVersion: String {
        return main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    static var buildVersion: String {
        return main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

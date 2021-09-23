//
//  OverlayConfiguration.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/19/20.
//

import UIKit

public protocol OverlayConfiguration {
    var items: [OverlayItem] { get }
}

final class OverlayConfigurationExample: OverlayConfiguration {
    private let storage = InMemoryStorage.shared

    lazy var items: [OverlayItem] = [
        exportLogs,
        toggleExample,
        copyUserId,
        appVersion,
        nestedMenu,
    ]

    private lazy var exportLogs: OverlayItem = {
        let item = OverlayItem(
            title: "Share Logs",
            action: .present(view: { _ in
                var items: [Any] = []
//                items.append(Debug_LogArchiver.debugDeviceSummary)
//                items.append(contentsOf: Debug_LogArchiver.makeAttachmentURLs())
                let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activity.excludedActivityTypes = [.postToFacebook, .addToReadingList, .assignToContact]
                return activity
            })
        )
        return item
    }()

    private lazy var toggleExample: OverlayItem = {
        let enabled = "Toggle Example: Active"
        let disabled = "Toggle Example: Inactive"
        let title = storage.isDebugPremiumActive ?
            enabled :
            disabled

        let item = OverlayItem(title: title, action: .action { [weak self] item in
            guard let self = self else { return }
            self.storage.isDebugPremiumActive.toggle()
            item.title = self.storage.isDebugPremiumActive ? enabled : disabled
            item.setNeedsToUpdateItem()
        })

        return item
    }()

    private lazy var copyUserId: OverlayItem = {
        let userId = "Your userId"
        let title = "Copy UserId"
        let item = OverlayItem(title: title, subtitle: userId, action: .action { _ in
            UIPasteboard.general.string = userId
        })
        return item
    }()

    private lazy var appVersion: OverlayItem = {
        var configuration: String = "Configuration: Debug"
        let item = OverlayItem(
            title: configuration,
            subtitle: "Version: \(Bundle.marketingVersion) Build: \(Bundle.buildVersion)",
            action: .action { _ in
                UIPasteboard.general.string = "Version \(Bundle.marketingVersion) (\(Bundle.buildVersion))"
            }
        )
        return item
    }()

    private lazy var nestedMenu: OverlayItem = {
        let subitems: [OverlayItem] = [
            .init(title: "Some", action: .action { _ in }),
            .init(title: "Nested", action: .action { _ in }),
            .init(title: "Items", action: .action { _ in  }),
            .init(title: "Duh", action: .action { _ in
            }),
            .init(title: "Crash (for real)", action: .action { _ in fatalError("Test Fatal Error Text.") }),
        ]
        let item = OverlayItem(
            title: "Nested Menu",
            action: .sublist(items: subitems)
        )
        return item
    }()
}

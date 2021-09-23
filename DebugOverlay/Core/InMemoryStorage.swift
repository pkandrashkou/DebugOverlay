//
//  InMemoryStorage.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 12/18/20.
//

final class InMemoryStorage {
    static let shared: InMemoryStorage = .init()
    var isDebugPremiumActive: Bool = false

    private init() { }
}

//
//  UpdaterManager.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-03.
//

import Sparkle

/// Owns the Sparkle updater lifecycle for the duration of the app.
/// Instantiated once in The_PauseApp and kept alive for the app's lifetime.
final class UpdaterManager {
    let updaterController: SPUStandardUpdaterController

    init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }

    /// Triggers an explicit user-initiated update check.
    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }
}

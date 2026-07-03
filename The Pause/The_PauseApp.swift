//
//  The_PauseApp.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import SwiftUI

@main
struct The_PauseApp: App {
    @State private var session = ExerciseSession()

    // Sparkle updater — must be held strongly for the app lifetime.
    private let updaterManager = UpdaterManager()

    init() {
        LaunchAtLogin.enableIfNeeded()
    }

    var body: some Scene {
        MenuBarExtra {
            ContentView(session: session, updaterManager: updaterManager)
                .frame(width: 320, height: 400)
        } label: {
            Image(systemName: "brain.head.profile.fill")
                .symbolRenderingMode(.hierarchical)
        }
        .menuBarExtraStyle(.window)
    }
}

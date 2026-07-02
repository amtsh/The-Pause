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

    init() {
        LaunchAtLogin.enableIfNeeded()
    }

    var body: some Scene {
        MenuBarExtra {
            ContentView(session: session)
                .frame(width: 320, height: 400)
        } label: {
            Label("The Pause", systemImage: "brain.head.profile.fill")
        }
        .menuBarExtraStyle(.window)
    }
}

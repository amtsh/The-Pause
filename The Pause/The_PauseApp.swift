//
//  The_PauseApp.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import SwiftUI
import SwiftData

@main
struct The_PauseApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        MenuBarExtra("The Pause", systemImage: "pause.circle.fill") {
            ContentView()
                .frame(width: 320, height: 400)
        }
        .menuBarExtraStyle(.window)
        .modelContainer(sharedModelContainer)
    }
}

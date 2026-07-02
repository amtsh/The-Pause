//
//  LaunchAtLogin.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import ServiceManagement

enum LaunchAtLogin {
    static var isEnabled: Bool {
        switch SMAppService.mainApp.status {
        case .enabled, .requiresApproval:
            return true
        case .notRegistered, .notFound:
            return false
        @unknown default:
            return false
        }
    }

    static func setEnabled(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            NSLog("The Pause: failed to update launch at login — \(error.localizedDescription)")
        }
    }

    static func enableIfNeeded() {
        guard SMAppService.mainApp.status == .notRegistered else { return }
        setEnabled(true)
    }
}

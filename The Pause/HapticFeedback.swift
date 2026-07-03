//
//  HapticFeedback.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import AppKit

enum HapticFeedback {
    static func navigate() {
        NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .now)
    }
}

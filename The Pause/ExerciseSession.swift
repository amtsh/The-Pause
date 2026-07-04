//
//  ExerciseSession.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import AppKit
import SwiftUI

private extension Notification.Name {
    static let windowWillOrderOnScreen = Notification.Name("NSWindowWillOrderOnScreenNotification")
    static let windowDidOrderOffScreen = Notification.Name("NSWindowDidOrderOffScreenNotification")
}

private enum PopoverWindow {
    static let identifier = NSUserInterfaceItemIdentifier("ThePausePopover")
}

enum ExerciseNavigationDirection: Equatable {
    case forward
    case backward
    case neutral
}

@MainActor
@Observable
final class ExerciseSession {
    var exerciseMode: PauseExerciseMode = .mind {
        didSet {
            // When mode changes, jump to a random exercise in the new mode.
            exercise = PauseExercise.random(mode: exerciseMode, excluding: exercise)
        }
    }

    var exercise = PauseExercise.random(mode: .mind)
    var navigationDirection = ExerciseNavigationDirection.neutral
    private var isDismissed = true
    private var didInstallObservers = false

    func installIfNeeded() {
        guard !didInstallObservers else { return }
        didInstallObservers = true

        let center = NotificationCenter.default
        let openEvents: [Notification.Name] = [
            NSWindow.didBecomeKeyNotification,
            .windowWillOrderOnScreen,
        ]
        let closeEvents: [Notification.Name] = [
            NSWindow.didResignKeyNotification,
            NSWindow.willCloseNotification,
            .windowDidOrderOffScreen,
        ]

        for name in openEvents {
            center.addObserver(forName: name, object: nil, queue: .main) { [weak self] notification in
                guard let self, let window = notification.object as? NSWindow else { return }
                Task { @MainActor in
                    self.handleWindowShown(window)
                }
            }
        }

        for name in closeEvents {
            center.addObserver(forName: name, object: nil, queue: .main) { [weak self] notification in
                guard let self, let window = notification.object as? NSWindow else { return }
                Task { @MainActor in
                    self.handleWindowHidden(window)
                }
            }
        }
    }

    func tagPopoverWindow(from view: NSView) {
        guard let window = view.window else { return }
        window.identifier = PopoverWindow.identifier
        configurePopoverWindow(window)
        if window.isVisible {
            handleWindowShown(window)
        }
    }

    private func configurePopoverWindow(_ window: NSWindow) {
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.styleMask.insert(.fullSizeContentView)
        window.isOpaque = false
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = false
        window.hasShadow = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
    }

    func showPrevious() {
        navigationDirection = .backward
        exercise = exercise.previous
    }

    func showNext() {
        navigationDirection = .forward
        exercise = exercise.next
    }

    private func handleWindowShown(_ window: NSWindow) {
        guard window.identifier == PopoverWindow.identifier else { return }
        guard isDismissed else { return }
        isDismissed = false
        navigationDirection = .neutral
        exercise = PauseExercise.random(mode: exerciseMode, excluding: exercise)
    }

    private func handleWindowHidden(_ window: NSWindow) {
        guard window.identifier == PopoverWindow.identifier else { return }
        isDismissed = true
    }
}

fileprivate struct PopoverWindowTagger: NSViewRepresentable {
    let session: ExerciseSession

    func makeNSView(context: Context) -> NSView {
        let view = WindowObservingView()
        view.onWindowChange = { view in
            session.tagPopoverWindow(from: view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let nsView = nsView as? WindowObservingView else { return }
        nsView.onWindowChange = { view in
            session.tagPopoverWindow(from: view)
        }
        session.tagPopoverWindow(from: nsView)
    }

    private final class WindowObservingView: NSView {
        var onWindowChange: ((NSView) -> Void)?

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            onWindowChange?(self)
        }
    }
}

extension View {
    func trackPopoverWindow(session: ExerciseSession) -> some View {
        background(PopoverWindowTagger(session: session))
    }
}

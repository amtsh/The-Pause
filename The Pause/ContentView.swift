//
//  ContentView.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import SwiftUI

struct ContentView: View {
    var session: ExerciseSession
    var updaterManager: UpdaterManager

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var launchAtLogin = LaunchAtLogin.isEnabled

    private let horizontalPadding: CGFloat = 16
    private let sectionVerticalPadding: CGFloat = 10
    private let popoverCornerRadius: CGFloat = 10

    var body: some View {
        VStack(spacing: 0) {
            NeighborRow(
                label: "Previous",
                chevron: "chevron.up",
                title: session.exercise.previous.title,
                contentID: session.exercise.id,
                horizontalPadding: horizontalPadding,
                reduceMotion: reduceMotion,
                action: { navigatePrevious() }
            )

            sectionDivider()

            ExerciseContent(exercise: session.exercise, reduceMotion: reduceMotion)
                .id(session.exercise.id)
                .transition(exerciseTransition)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, sectionVerticalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .clipped()
                .animation(exerciseAnimation, value: session.exercise.id)

            sectionDivider()

            NeighborRow(
                label: "Next",
                chevron: "chevron.down",
                title: session.exercise.next.title,
                contentID: session.exercise.id,
                horizontalPadding: horizontalPadding,
                reduceMotion: reduceMotion,
                action: { navigateNext() }
            )

            sectionDivider()

            HStack(spacing: 10) {
                modeSelector

                Spacer()

                Text("The Pause")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()

                Menu {
                    Toggle("Launch at Login", isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { _, newValue in
                            LaunchAtLogin.setEnabled(newValue)
                            launchAtLogin = LaunchAtLogin.isEnabled
                        }

                    Divider()

                    Button("Check for Updates\u{2026}") {
                        updaterManager.checkForUpdates()
                    }

                    Divider()

                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                    .keyboardShortcut("q")
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                .menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .fixedSize()
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 8)
        }
        .background {
            RoundedRectangle(cornerRadius: popoverCornerRadius, style: .continuous)
                .fill(.regularMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: popoverCornerRadius, style: .continuous)
                        .strokeBorder(.primary.opacity(0.06), lineWidth: 0.5)
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: popoverCornerRadius, style: .continuous))
        .focusable()
        .onKeyPress(.leftArrow) {
            navigatePrevious()
            return .handled
        }
        .onKeyPress(.rightArrow) {
            navigateNext()
            return .handled
        }
        .onKeyPress(.upArrow) {
            navigatePrevious()
            return .handled
        }
        .onKeyPress(.downArrow) {
            navigateNext()
            return .handled
        }
        .trackPopoverWindow(session: session)
        .onAppear {
            session.installIfNeeded()
            launchAtLogin = LaunchAtLogin.isEnabled
        }
    }

    private var modeSelector: some View {
        HStack(spacing: 4) {
            modeButton(title: "Mind", mode: .mind)
            modeButton(title: "Voice", mode: .voice)
        }
        .font(.footnote)
    }

    private func modeButton(title: String, mode: PauseExerciseMode) -> some View {
        Button {
            session.exerciseMode = mode
        } label: {
            Text(title)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(session.exerciseMode == mode ? Color.primary.opacity(0.12) : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(session.exerciseMode == mode ? Color.primary.opacity(0.4) : Color.secondary.opacity(0.2), lineWidth: 0.5)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title) exercises")
    }

    private func sectionDivider() -> some View {
        Divider()
            .opacity(0.45)
            .padding(.horizontal, horizontalPadding)
    }

    private var exerciseAnimation: Animation? {
        reduceMotion ? nil : .spring(response: 0.34, dampingFraction: 0.86)
    }

    private var exerciseTransition: AnyTransition {
        guard !reduceMotion else { return .identity }

        switch session.navigationDirection {
        case .forward:
            return .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            )
        case .backward:
            return .asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
        case .neutral:
            return .opacity
        }
    }

    private func navigatePrevious() {
        HapticFeedback.navigate()
        session.showPrevious()
    }

    private func navigateNext() {
        HapticFeedback.navigate()
        session.showNext()
    }
}

private struct ExerciseContent: View {
    let exercise: PauseExercise
    let reduceMotion: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            exerciseIcon
                .padding(.bottom, 2)
                .accessibilityHidden(true)

            Text(exercise.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(exercise.todo)
                .font(.body)

            Text("Effect: \(exercise.effect)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var exerciseIcon: some View {
        let icon = Image(systemName: exercise.symbolName)
            .font(.system(size: 26, weight: .light))
            .foregroundStyle(.tertiary)
            .symbolRenderingMode(.hierarchical)

        if reduceMotion {
            icon
        } else {
            icon.symbolEffect(.bounce, value: exercise.id)
        }
    }
}

private struct NeighborRow: View {
    let label: String
    let chevron: String
    let title: String
    let contentID: String
    let horizontalPadding: CGFloat
    let reduceMotion: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: chevron)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(isHovered ? Color.primary.opacity(0.55) : Color.secondary)

                Text(label)

                Spacer()

                Text(title)
                    .lineLimit(1)
                    .contentTransition(.opacity)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isHovered ? Color.primary.opacity(0.06) : Color.clear)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PressablePlainButtonStyle(reduceMotion: reduceMotion))
        .animation(reduceMotion ? nil : .easeOut(duration: 0.15), value: isHovered)
        .animation(reduceMotion ? nil : .spring(response: 0.34, dampingFraction: 0.86), value: contentID)
        .onHover { isHovered = $0 }
        .accessibilityLabel("\(label) exercise: \(title)")
        .help("\(label): \(title)")
    }
}

private struct PressablePlainButtonStyle: ButtonStyle {
    let reduceMotion: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.985 : 1)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

#Preview {
    ContentView(session: ExerciseSession(), updaterManager: UpdaterManager())
        .frame(width: 320, height: 400)
}

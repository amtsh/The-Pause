//
//  ContentView.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import SwiftUI

struct ContentView: View {
    var session: ExerciseSession

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var launchAtLogin = LaunchAtLogin.isEnabled

    private let horizontalPadding: CGFloat = 16
    private let sectionVerticalPadding: CGFloat = 10
    private let popoverCornerRadius: CGFloat = 10
    private let exerciseTransitionDuration: Double = 0.22

    var body: some View {
        VStack(spacing: 0) {
            NeighborRow(
                label: "Previous",
                chevron: "chevron.up",
                title: session.exercise.previous.title,
                horizontalPadding: horizontalPadding,
                action: { navigatePrevious() }
            )

            sectionDivider()

            ExerciseContent(exercise: session.exercise)
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
                horizontalPadding: horizontalPadding,
                action: { navigateNext() }
            )

            sectionDivider()

            HStack {
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

    private func sectionDivider() -> some View {
        Divider()
            .padding(.horizontal, horizontalPadding)
    }

    private var exerciseAnimation: Animation? {
        reduceMotion ? nil : .easeInOut(duration: exerciseTransitionDuration)
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
        session.showPrevious()
    }

    private func navigateNext() {
        session.showNext()
    }
}

private struct ExerciseContent: View {
    let exercise: PauseExercise

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.title)
                .font(.title3.weight(.semibold))

            Text(exercise.todo)
                .font(.body)

            Text("Effect: \(exercise.effect)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

private struct NeighborRow: View {
    let label: String
    let chevron: String
    let title: String
    let horizontalPadding: CGFloat
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: chevron)
                    .font(.footnote.weight(.semibold))

                Text(label)

                Spacer()

                Text(title)
                    .lineLimit(1)
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
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .accessibilityLabel("\(label) exercise: \(title)")
        .help("\(label): \(title)")
    }
}

#Preview {
    ContentView(session: ExerciseSession())
        .frame(width: 320, height: 400)
}

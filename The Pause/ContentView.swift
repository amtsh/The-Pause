//
//  ContentView.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import SwiftUI

struct ContentView: View {
    var session: ExerciseSession

    private let contentFontScale: CGFloat = 1.3225
    private let horizontalPadding: CGFloat = 16
    private let sectionVerticalPadding: CGFloat = 10

    var body: some View {
        VStack(spacing: 0) {
            neighborRow(label: "Previous", title: session.exercise.previous.title) {
                session.showPrevious()
            }

            sectionDivider()

            VStack(alignment: .leading, spacing: 12) {
                Text(session.exercise.title)
                    .font(.system(size: 17 * contentFontScale, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text(session.exercise.todo)
                    .font(.system(size: 13 * contentFontScale))

                Text("Effect: \(session.exercise.effect)")
                    .font(.system(size: 13.8))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, sectionVerticalPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            sectionDivider()

            neighborRow(label: "Next", title: session.exercise.next.title) {
                session.showNext()
            }

            sectionDivider()

            HStack {
                Text("The Pause")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q")
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, 8)
        }
        .trackPopoverWindow(session: session)
        .onAppear {
            session.installIfNeeded()
        }
    }

    private func neighborRow(label: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(label)
                Spacer()
                Text(title)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .font(.system(size: 11))
        .foregroundStyle(.secondary)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 8)
    }

    private func sectionDivider() -> some View {
        Divider()
            .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    ContentView(session: ExerciseSession())
        .frame(width: 320, height: 400)
}

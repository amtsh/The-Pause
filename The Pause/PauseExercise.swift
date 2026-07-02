//
//  PauseExercise.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import Foundation

struct PauseExercise: Identifiable, Equatable {
    let id: String
    let title: String
    let todo: String
    let effect: String

    static let all: [PauseExercise] = [
        PauseExercise(
            id: "one-slow-breath",
            title: "One Slow Breath",
            todo: "Take one slow breath before starting anything new.",
            effect: "Interrupts autopilot and activates calmer nervous-system control."
        ),
        PauseExercise(
            id: "relax-the-face",
            title: "Relax the Face",
            todo: "Soften your jaw, tongue, eyes, and forehead for 20 seconds.",
            effect: "Reduces hidden stress signals feeding back into the brain."
        ),
        PauseExercise(
            id: "shoulder-drop",
            title: "Shoulder Drop",
            todo: "Let your shoulders fall naturally and release tension.",
            effect: "Tells the body you are not under threat."
        ),
        PauseExercise(
            id: "feel-the-hands",
            title: "Feel the Hands",
            todo: "Notice your hands resting on the desk, lap, or keyboard.",
            effect: "Grounds attention in the body instead of runaway thoughts."
        ),
        PauseExercise(
            id: "name-the-mood",
            title: "Name the Mood",
            todo: "Silently label your state: “rushed,” “angry,” “tired,” or “restless.”",
            effect: "Naming emotion reduces its grip. Basic brain trick, annoyingly effective."
        ),
        PauseExercise(
            id: "watch-the-urge",
            title: "Watch the Urge",
            todo: "When you want to switch tasks, pause for 30 seconds first.",
            effect: "Builds impulse control and weakens distraction loops."
        ),
        PauseExercise(
            id: "one-thing-only",
            title: "One Thing Only",
            todo: "Give full attention to one task for 5 minutes.",
            effect: "Trains attention stability. Multitasking is mostly self-sabotage."
        ),
        PauseExercise(
            id: "soft-gaze",
            title: "Soft Gaze",
            todo: "Relax your eyes and look gently, without staring.",
            effect: "Lowers strain and reduces mental tightening."
        ),
        PauseExercise(
            id: "kind-thought",
            title: "Kind Thought",
            todo: "Silently wish yourself and others ease for 10 seconds.",
            effect: "Trains compassion and reduces hostile inner chatter."
        ),
        PauseExercise(
            id: "let-go-exhale",
            title: "Let Go Exhale",
            todo: "With each exhale, release one small tension in the body.",
            effect: "Links breathing with release, making calm easier to access."
        ),
    ]

    static func random(excluding previous: PauseExercise? = nil) -> PauseExercise {
        let pool = all.filter { $0.id != previous?.id }
        return pool.randomElement() ?? all[0]
    }

    var previous: PauseExercise {
        let exercises = Self.all
        guard let index = exercises.firstIndex(where: { $0.id == id }) else {
            return exercises[exercises.count - 1]
        }
        return exercises[(index - 1 + exercises.count) % exercises.count]
    }

    var next: PauseExercise {
        let exercises = Self.all
        guard let index = exercises.firstIndex(where: { $0.id == id }) else {
            return exercises[0]
        }
        return exercises[(index + 1) % exercises.count]
    }
}

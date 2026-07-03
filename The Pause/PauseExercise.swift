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
        PauseExercise(
            id: "silent-counting",
            title: "Silent Counting",
            todo: "Count 10 breaths. Restart if the mind wanders.",
            effect: "Builds attention control without drama."
        ),
        PauseExercise(
            id: "belly-check",
            title: "Belly Check",
            todo: "Notice if your belly is tight. Let it soften.",
            effect: "Reduces threat-mode tension."
        ),
        PauseExercise(
            id: "thought-watching",
            title: "Thought Watching",
            todo: "Watch one thought arise and fade without following it.",
            effect: "Trains detachment from mental noise."
        ),
        PauseExercise(
            id: "no-fixing-pause",
            title: "No Fixing Pause",
            todo: "Sit for 30 seconds without trying to improve anything.",
            effect: "Weakens the constant control habit."
        ),
        PauseExercise(
            id: "gratitude-flash",
            title: "Gratitude Flash",
            todo: "Name one ordinary thing you are grateful for.",
            effect: "Shifts the brain away from scarcity and complaint loops."
        ),
        PauseExercise(
            id: "inner-smile",
            title: "Inner Smile",
            todo: "Slightly soften the face as if gently smiling inside.",
            effect: "Calms emotional tone without forcing happiness."
        ),
        PauseExercise(
            id: "sound-awareness",
            title: "Sound Awareness",
            todo: "Listen to all sounds equally for 30 seconds.",
            effect: "Expands awareness beyond narrow self-focus."
        ),
        PauseExercise(
            id: "desire-label",
            title: "Desire Label",
            todo: "When wanting something, label it: “wanting.”",
            effect: "Reduces craving by making it visible."
        ),
        PauseExercise(
            id: "enough-moment",
            title: "Enough Moment",
            todo: "Silently say: “This moment is enough.”",
            effect: "Counters restless chasing and future obsession."
        ),
        PauseExercise(
            id: "compassion-breath",
            title: "Compassion Breath",
            todo: "Inhale: “I notice.” Exhale: “I soften.”",
            effect: "Links awareness with kindness, not self-attack."
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

    var symbolName: String {
        switch id {
        case "one-slow-breath": return "wind"
        case "relax-the-face": return "face.smiling"
        case "shoulder-drop": return "figure.stand"
        case "feel-the-hands": return "hand.raised"
        case "name-the-mood": return "brain.head.profile"
        case "watch-the-urge": return "eye"
        case "one-thing-only": return "scope"
        case "soft-gaze": return "eye.circle"
        case "kind-thought": return "heart"
        case "let-go-exhale": return "lungs.fill"
        case "silent-counting": return "10.circle"
        case "belly-check": return "figure.mind.and.body"
        case "thought-watching": return "cloud"
        case "no-fixing-pause": return "pause.circle"
        case "gratitude-flash": return "sparkles"
        case "inner-smile": return "sun.max"
        case "sound-awareness": return "ear"
        case "desire-label": return "tag"
        case "enough-moment": return "checkmark.circle"
        case "compassion-breath": return "heart.circle"
        default: return "leaf"
        }
    }
}

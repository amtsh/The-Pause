//
//  PauseExercise.swift
//  The Pause
//
//  Created by Amit Shinde on 2026-07-02.
//

import Foundation

enum PauseExerciseMode: String, CaseIterable {
    case mind
    case voice
}

struct PauseExercise: Identifiable, Equatable {
    let id: String
    let title: String
    let todo: String
    let effect: String
    let mode: PauseExerciseMode

    static let all: [PauseExercise] = [
        PauseExercise(
            id: "one-slow-breath",
            title: "One Slow Breath",
            todo: "Take one slow breath before starting anything new.",
            effect: "Interrupts autopilot and activates calmer nervous-system control.",
            mode: .mind
        ),
        PauseExercise(
            id: "relax-the-face",
            title: "Relax the Face",
            todo: "Soften your jaw, tongue, eyes, and forehead for 20 seconds.",
            effect: "Reduces hidden stress signals feeding back into the brain.",
            mode: .mind
        ),
        PauseExercise(
            id: "shoulder-drop",
            title: "Shoulder Drop",
            todo: "Let your shoulders fall naturally and release tension.",
            effect: "Tells the body you are not under threat.",
            mode: .mind
        ),
        PauseExercise(
            id: "feel-the-hands",
            title: "Feel the Hands",
            todo: "Notice your hands resting on the desk, lap, or keyboard.",
            effect: "Grounds attention in the body instead of runaway thoughts.",
            mode: .mind
        ),
        PauseExercise(
            id: "name-the-mood",
            title: "Name the Mood",
            todo: "Silently label your state: “rushed,” “angry,” “tired,” or “restless.”",
            effect: "Naming emotion reduces its grip. Basic brain trick, annoyingly effective.",
            mode: .mind
        ),
        PauseExercise(
            id: "watch-the-urge",
            title: "Watch the Urge",
            todo: "When you want to switch tasks, pause for 30 seconds first.",
            effect: "Builds impulse control and weakens distraction loops.",
            mode: .mind
        ),
        PauseExercise(
            id: "one-thing-only",
            title: "One Thing Only",
            todo: "Give full attention to one task for 5 minutes.",
            effect: "Trains attention stability. Multitasking is mostly self-sabotage.",
            mode: .mind
        ),
        PauseExercise(
            id: "soft-gaze",
            title: "Soft Gaze",
            todo: "Relax your eyes and look gently, without staring.",
            effect: "Lowers strain and reduces mental tightening.",
            mode: .mind
        ),
        PauseExercise(
            id: "kind-thought",
            title: "Kind Thought",
            todo: "Silently wish yourself and others ease for 10 seconds.",
            effect: "Trains compassion and reduces hostile inner chatter.",
            mode: .mind
        ),
        PauseExercise(
            id: "let-go-exhale",
            title: "Let Go Exhale",
            todo: "With each exhale, release one small tension in the body.",
            effect: "Links breathing with release, making calm easier to access.",
            mode: .mind
        ),
        PauseExercise(
            id: "silent-counting",
            title: "Silent Counting",
            todo: "Count 10 breaths. Restart if the mind wanders.",
            effect: "Builds attention control without drama.",
            mode: .mind
        ),
        PauseExercise(
            id: "belly-check",
            title: "Belly Check",
            todo: "Notice if your belly is tight. Let it soften.",
            effect: "Reduces threat-mode tension.",
            mode: .mind
        ),
        PauseExercise(
            id: "thought-watching",
            title: "Thought Watching",
            todo: "Watch one thought arise and fade without following it.",
            effect: "Trains detachment from mental noise.",
            mode: .mind
        ),
        PauseExercise(
            id: "no-fixing-pause",
            title: "No Fixing Pause",
            todo: "Sit for 30 seconds without trying to improve anything.",
            effect: "Weakens the constant control habit.",
            mode: .mind
        ),
        PauseExercise(
            id: "gratitude-flash",
            title: "Gratitude Flash",
            todo: "Name one ordinary thing you are grateful for.",
            effect: "Shifts the brain away from scarcity and complaint loops.",
            mode: .mind
        ),
        PauseExercise(
            id: "inner-smile",
            title: "Inner Smile",
            todo: "Slightly soften the face as if gently smiling inside.",
            effect: "Calms emotional tone without forcing happiness.",
            mode: .mind
        ),
        PauseExercise(
            id: "sound-awareness",
            title: "Sound Awareness",
            todo: "Listen to all sounds equally for 30 seconds.",
            effect: "Expands awareness beyond narrow self-focus.",
            mode: .mind
        ),
        PauseExercise(
            id: "desire-label",
            title: "Desire Label",
            todo: "When wanting something, label it: “wanting.”",
            effect: "Reduces craving by making it visible.",
            mode: .mind
        ),
        PauseExercise(
            id: "enough-moment",
            title: "Enough Moment",
            todo: "Silently say: “This moment is enough.”",
            effect: "Counters restless chasing and future obsession.",
            mode: .mind
        ),
        PauseExercise(
            id: "compassion-breath",
            title: "Compassion Breath",
            todo: "Inhale: “I notice.” Exhale: “I soften.”",
            effect: "Links awareness with kindness, not self-attack.",
            mode: .mind
        ),

        // Voice pack (opt-in via mode selector)
        PauseExercise(
            id: "yawn-sigh",
            title: "Yawn–Sigh",
            todo: "Take a gentle silent yawn, sustain a soft “ah” on one easy pitch, then let it relax into a sigh.",
            effect: "Releases throat tension and opens space so your voice feels freer and less tight.",
            mode: .voice
        ),
        PauseExercise(
            id: "scale-hum",
            title: "Scale Hum",
            todo: "With lips closed, hum a comfortable note, then move up and down a simple 5‑note pattern quietly.",
            effect: "Gently warms the voice and encourages clear, forward resonance without straining.",
            mode: .voice
        ),
        PauseExercise(
            id: "lip-trills",
            title: "Lip Trills",
            todo: "Let the lips flutter in a soft “brrr” sound on one pitch or a small slide, using minimal air.",
            effect: "Loosens lips and connects breath to tone for a smoother, more resonant voice.",
            mode: .voice
        ),
        PauseExercise(
            id: "mm-to-ah",
            title: "Mm to Ah",
            todo: "Sustain “mm” on one pitch, feel the facial buzz, then open to “mah” while keeping the buzz forward.",
            effect: "Moves resonance from closed to open vowels, improving clarity and richness of spoken tone.",
            mode: .voice
        ),
        PauseExercise(
            id: "ng-resonance",
            title: "Ng Resonance",
            todo: "Hold the “ng” from “sing” on one pitch, tongue up, teeth apart, keeping the sound light and buzzy.",
            effect: "Builds easy head resonance so your voice carries better without extra volume.",
            mode: .voice
        ),
        PauseExercise(
            id: "nasal-patterns",
            title: "Nasal Patterns",
            todo: "Repeat “ma‑ma‑ma” and “na‑na‑na” on simple pitches, staying relaxed and slightly forward in the mask.",
            effect: "Strengthens forward resonance, giving speech more brightness and projection.",
            mode: .voice
        ),
        PauseExercise(
            id: "articulation-drill",
            title: "Articulation Drill",
            todo: "Say a short tongue twister very slowly with exaggerated consonants, then slightly increase speed while staying clear.",
            effect: "Sharpens consonants so your words are easier to understand in calls and meetings.",
            mode: .voice
        ),
    ]

    static func random(mode: PauseExerciseMode, excluding previous: PauseExercise? = nil) -> PauseExercise {
        let pool = all.filter { $0.mode == mode && $0.id != previous?.id }
        return pool.randomElement() ?? all.first(where: { $0.mode == mode }) ?? all[0]
    }

    var previous: PauseExercise {
        let exercises = Self.all
        let sameMode = exercises.filter { $0.mode == mode }
        guard let index = sameMode.firstIndex(where: { $0.id == id }) else {
            return sameMode.last ?? exercises[exercises.count - 1]
        }
        return sameMode[(index - 1 + sameMode.count) % sameMode.count]
    }

    var next: PauseExercise {
        let exercises = Self.all
        let sameMode = exercises.filter { $0.mode == mode }
        guard let index = sameMode.firstIndex(where: { $0.id == id }) else {
            return sameMode.first ?? exercises[0]
        }
        return sameMode[(index + 1) % sameMode.count]
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

        // Voice icons
        case "yawn-sigh": return "mouth"
        case "scale-hum": return "waveform"
        case "lip-trills": return "mouth.fill"
        case "mm-to-ah": return "textformat"
        case "ng-resonance": return "brain.head.profile"
        case "nasal-patterns": return "nose"
        case "articulation-drill": return "character.cursor.ibeam"
        default: return "leaf"
        }
    }
}

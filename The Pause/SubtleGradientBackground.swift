//
//  SubtleGradientBackground.swift
//  The Pause
//

import SwiftUI

struct SubtleGradientBackground: View {
    let reduceMotion: Bool
    var accentPhase: Double = 0

    @Environment(\.colorScheme) private var colorScheme

    /// 12 fps — smooth enough for slow drift, cheap on battery.
    private let frameInterval: TimeInterval = 1.0 / 12.0

    var body: some View {
        TimelineView(.periodic(from: .now, by: frameInterval)) { timeline in
            Canvas { context, size in
                guard size.width > 1, size.height > 1 else { return }

                let time = timeline.date.timeIntervalSinceReferenceDate
                let phase = reduceMotion ? accentPhase : time

                fillBase(in: &context, size: size)

                for index in 0..<3 {
                    paintOrb(
                        in: &context,
                        size: size,
                        time: phase,
                        index: index
                    )
                }
            }
        }
        .blur(radius: 36)
        .drawingGroup()
        .allowsHitTesting(false)
    }

    private func fillBase(in context: inout GraphicsContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        let base = colorScheme == .dark
            ? Color(red: 0.07, green: 0.08, blue: 0.11)
            : Color(red: 0.96, green: 0.97, blue: 0.99)
        context.fill(Path(rect), with: .color(base))
    }

    private func paintOrb(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval,
        index: Int
    ) {
        let indexDouble = Double(index)
        let span = max(size.width, size.height)
        let speed = 0.05 + indexDouble * 0.009
        let angle = time * speed + indexDouble * 2.09 + accentPhase

        let center = CGPoint(
            x: size.width * (0.5 + 0.30 * cos(angle * 0.9 + indexDouble)),
            y: size.height * (0.5 + 0.34 * sin(angle * 0.75 + indexDouble * 1.3))
        )

        let hue = hueValue(time: time, index: index)
        let orbColor = Color(hue: hue, saturation: saturation, brightness: brightness)
        let radius = span * (0.36 + 0.05 * sin(angle * 1.1))

        let rect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )

        context.fill(
            Path(ellipseIn: rect),
            with: .radialGradient(
                Gradient(colors: [
                    orbColor.opacity(orbOpacity),
                    orbColor.opacity(orbOpacity * 0.4),
                    orbColor.opacity(0),
                ]),
                center: center,
                startRadius: 0,
                endRadius: radius
            )
        )
    }

    private func hueValue(time: TimeInterval, index: Int) -> Double {
        let indexDouble = Double(index)
        let drift = reduceMotion ? accentPhase : time * 0.04
        let wave = sin(drift * 1.2 + indexDouble * 1.7) * 0.08
            + cos(drift * 0.85 + indexDouble * 2.4) * 0.06
        let baseHue = colorScheme == .dark ? 0.58 : 0.54
        return (baseHue + wave + indexDouble * 0.12 + accentPhase * 0.02)
            .truncatingRemainder(dividingBy: 1.0)
    }

    private var saturation: Double {
        colorScheme == .dark ? 0.45 : 0.42
    }

    private var brightness: Double {
        colorScheme == .dark ? 0.74 : 0.95
    }

    private var orbOpacity: Double {
        colorScheme == .dark ? 0.62 : 0.55
    }
}

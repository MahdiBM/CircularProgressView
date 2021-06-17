//
//  CircleArc.swift
//  CircularProgressView
//
//  Created by Mahdi
//

import SwiftUI

/// Draws a stroked path of an arc of a circle.
struct CircleArc: Shape {
    /// The left hand angle.
    var startAngle: Angle
    /// The right hand angle.
    var endAngle: Angle
    /// The width of the stroke.
    var lineWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        /// Don't really know why is that, but to draw a pod-clockwise arc from
        /// `startAngle` to `endAngle` you need to pass their negative values.
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true
        )
        path = path.strokedPath(.init(lineWidth: lineWidth, lineCap: .round))
        return path
    }
}

// Animatable conformance
extension CircleArc: Animatable {
    var animatableData: AnimatablePair<Double, Double> {
        get { .init(startAngle.radians, endAngle.radians) }
        set {
            startAngle = .radians(newValue.first)
            endAngle = .radians(newValue.second)
        }
    }
}

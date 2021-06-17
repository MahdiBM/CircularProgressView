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

/*
 /// Draws a stroked path of an arc of a circle.
 struct CircleArc: Shape {
 /// The left hand angle.
 var startAngle: Angle
 /// The right hand angle.
 var endAngle: Angle
 /// The width of the stroke.
 var lineWidth: CGFloat
 /// Clockwise or pod-clockwise. Due to how `addArc` draws a circle, this is
 /// actually the reverse value.
 var isClockwise: Bool
 
 func path(in rect: CGRect) -> Path {
 var path = Path()
 /// Don't really know why is that, but to draw a pod-clockwise arc from
 /// `startAngle` to `endAngle` you need to pass their negative values
 /// and set `clockwise` to true.
 path.addArc(
 center: CGPoint(x: rect.midX, y: rect.midY),
 radius: rect.width / 2,
 startAngle: isClockwise ? startAngle : -startAngle,
 endAngle: isClockwise ? endAngle : -endAngle,
 clockwise: !isClockwise
 )
 path = path.strokedPath(.init(lineWidth: lineWidth, lineCap: .round))
 return path
 }
 }
 */

//
//  CircleOnPerimeter.swift
//  CircularProgressView
//
//  Created by Mahdi
//

import SwiftUI

/// Draws a circle on the perimeter of it's frame's biggest-centered circle.
struct CircleOnPerimeter: Shape {
    /// The angle at which the circle will be drawn.
    var angle: Angle
    /// Radius of this circle
    let circleRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        /// Radius of the bigger circle. It's automatically equal to half
        /// width of this shape's frame.
        let radius = rect.width / 2
        /// The default starting point is top left instead of center, so we have to
        /// center our little circle correctly. `+ circleRadius` is due to the
        /// misplacement that is caused by using `addRoundedRect(in:cornerSize:)`.
        let distanceFromMiddle = -radius + circleRadius
        /// `+ (.pi / 2)` is to set the starting point to right hand side of the frame.
        /// Because `CircleArc` uses that starting point as well, and also thats the
        /// correct point (at least for my calculations).
        /// Without `+ (.pi / 2)` the starting point we'll be the bottom point of the frame.
        let x = sin(angle.radians + (.pi / 2)) * radius - distanceFromMiddle
        let y = cos(angle.radians + (.pi / 2)) * radius - distanceFromMiddle
        /// The below rounded rectangle has `circleRadius * 2` width and height, and
        /// so if we give it `circleRadius` amount of `cornerSize`, it'll turn into a circle.
        let cornerSize: CGSize = .init(width: circleRadius, height: circleRadius)
        let rect: CGRect = .init(x: x, y: y, width: circleRadius * 2, height: circleRadius * 2)
        var path = Path()
        /// Drawing the circle
        path.addRoundedRect(in: rect, cornerSize: cornerSize)
        return path
    }
}

// Animatable conformance
extension CircleOnPerimeter: Animatable {
    var animatableData: Double {
        get { angle.radians }
        set { angle = .radians(newValue) }
    }
}

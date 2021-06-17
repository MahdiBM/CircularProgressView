//
//  ProgressGeometry.swift
//  CircularProgressView
//
//  Created by Mahdi
//

import SwiftUI

/// Container of geometry info that are used to make the progress-view.
struct ProgressGeometry {
    /// Angles of the big-gray-arc-stroke.
    let angles: (start: Angle, end: Angle)
    /// The angle relative to the amount of the progress we had.
    let progressedAngle: Angle
    /// The angle at which the little circle is drawn. (the green circle)
    let circleAngle: Angle
    /// The angles of the progress arc. (the blue arc stroke)
    let progressAngles: (start: Angle, end: Angle)
    /// Radius of the progress indicator.
    let indicatorRadius: CGFloat
    /// Starting value to be used for a SwiftUI View.
    static let zero: Self = .init(
        progress: 0, radius: 0, angle1: .zero, angle2: .zero,
        lineWidth: 0, rightToLeft: false, offsetAngle: .zero)
    
    init(
        progress: CGFloat,
        radius: CGFloat,
        angle1: Angle,
        angle2: Angle,
        lineWidth: CGFloat,
        rightToLeft: Bool,
        offsetAngle: Angle
    ) {
        let angles: (start: Angle, end: Angle) = {
            if angle2 > angle1 {
                return (angle1 - offsetAngle, angle2 - offsetAngle)
            } else {
                return (angle2 - offsetAngle, angle1 - offsetAngle)
            }
        }()
        /// The arc which is visible and progress-able. (the gray arc)
        let wholeArc: Angle = angles.end - angles.start
        let progressedAngle: Angle = .radians(wholeArc.radians * progress)
        let circleAngle: Angle = {
            if rightToLeft {
                return (progressedAngle + angles.start)
            } else {
                return (angles.end - progressedAngle)
            }
        }()
        let progressAngles: (start: Angle, end: Angle) = {
            if rightToLeft {
                return (start: angles.start, end: circleAngle)
            } else {
                return (start: circleAngle, end: angles.end)
            }
        }()
        let indicatorRadius = lineWidth * 2
        
        self.angles = angles
        self.progressedAngle = progressedAngle
        self.circleAngle = circleAngle
        self.progressAngles = progressAngles
        self.indicatorRadius = indicatorRadius
    }
}

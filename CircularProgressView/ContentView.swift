//
//  ContentView.swift
//  CircularProgressView
//
//  Created by Mahdi
//

import SwiftUI

struct ContentView: View {
    /// The Progress.
    @State var progress: CGFloat = 0.333 /* 0 <= progress <= 1 */
    /// The radius of the bigger circle everything is drawn on.
    @State var radius: CGFloat = 120
    /// Angle number 1.
    @State var angle1: Angle = .zero
    /// Angle number 2.
    @State var angle2: Angle = .radians(3 * .pi / 2)
    /// The stroke's width.
    @State var lineWidth: CGFloat = 8
    /// Right to left or left to right progressing.
    @State var rightToLeft = false
    /// The angle to offset `angle.start` and `angles.end` with.
    /// This will just turn the circle to make creating some arcs possible.
    @State var offsetAngle: Angle = .radians(.pi / 4)
    /// Starting and ending angles of the bigger gray stroke.
    var angles: (start: Angle, end: Angle) {
        if angle2 > angle1 {
            return (angle1 - offsetAngle, angle2 - offsetAngle)
        } else {
            return (angle2 - offsetAngle, angle1 - offsetAngle)
        }
    }
    /// The arc which is visible and progress-able. (the gray arc)
    var wholeArc: Angle {
        angles.end - angles.start
    }
    /// The angle relative to the amount of the progress we had.
    var progressedAngle: Angle {
        .radians(wholeArc.radians * progress)
    }
    /// The angle at which the little circle is drawn. (the green circle)
    var circleAngle: Angle {
        if rightToLeft  {
            return (progressedAngle + angles.start)
        } else {
            return (angles.end - progressedAngle)
        }
    }
    /// The angles for the progress arc. (the blue arc)
    var progressAngles: (start: Angle, end: Angle) {
        if rightToLeft {
            return (start: angles.start, end: circleAngle)
        } else {
            return (start: circleAngle, end: angles.end)
        }
    }
    
    var body: some View {
        VStack(spacing: 2) {
            /// Progress View
            CircleArc(startAngle: angles.start, endAngle: angles.end, lineWidth: lineWidth)
                .frame(width: radius * 2, height: radius * 2)
                .foregroundColor(.gray)
                .overlay(
                    CircleArc(
                        startAngle: progressAngles.start,
                        endAngle: progressAngles.end,
                        lineWidth: lineWidth
                    ).foregroundColor(.blue)
                )
                .overlay(
                    CircleOnPerimeter(angle: circleAngle, circleRadius: lineWidth * 2)
                        .foregroundColor(.green)
                )
            
            /// Controllers
            VStack {
                HStack {
                    Button("right to left: \(rightToLeft.description)") {
                        rightToLeft.toggle()
                    }
                    .padding(6)
                    
                    Button("toggle progress") {
                        if progress.rounded(.toNearestOrEven) == 0 {
                            progress = 1
                        } else {
                            progress = 0
                        }
                    }
                    .padding(6)
                }
                .font(.headline)
                
                Group {
                    Text("progress: \(progress)")
                    Slider(value: $progress, in: (0.001)...1)
                    
                    Text("\(angle1 > angle2 ? "end" : "start"): \(angle1.degrees)")
                    Slider(value: .init(
                        get: { angle1.degrees },
                        set: { angle1 = .degrees($0) }
                    ), in: 0...360)
                    
                    Text("\(angle1 > angle2 ? "start" : "end"): \(angle2.degrees)")
                    Slider(value: .init(
                        get: { angle2.degrees },
                        set: { angle2 = .degrees($0) }
                    ), in: (0.1)...359.9)
                    
                    Text("offset angle: \(offsetAngle.degrees)")
                    Slider(value: .init(
                        get: { offsetAngle.degrees },
                        set: { offsetAngle = .degrees($0) }
                    ), in: (0.1)...359.9)
                    
                    Text("width: \(lineWidth)")
                    Slider(value: $lineWidth, in: 1...40)
                }
            }
            .padding(.horizontal)
            
        }
        .animation(.easeInOut.speed(0.5))
        .onChange(of: progress) { newValue in
            /// Progress == 0 might result in animation errors.
            if newValue == 0 { progress = 0.001 }
        }
    }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

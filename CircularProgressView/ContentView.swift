//
//  ContentView.swift
//  CircularProgressView
//
//  Created by Mahdi
//

import SwiftUI

struct ContentView: View {
    /// The radius of the bigger circle everything is drawn on.
    let radius: CGFloat = 120
    /// The Progress.
    @State private var progress: CGFloat = 0.333 /* 0 <= progress <= 1 */
    /// Angle number 1.
    @State private var angle1: Angle = .zero
    /// Angle number 2.
    @State private var angle2: Angle = .radians(3 * .pi / 2)
    /// The stroke's width.
    @State private var lineWidth: CGFloat = 8
    /// Right to left or left to right progressing.
    @State private var rightToLeft: Bool = false
    /// The angle to offset `angle.start` and `angles.end` with.
    /// This will just turn the circle to make creating some arcs possible.
    @State private var offsetAngle: Angle = .radians(.pi / 4)
    /// The geometry used to draw shapes.
    @State private var geo: ProgressGeometry = .zero
    
    var body: some View {
        
        populateProgressGeometry()
        
        return VStack(spacing: 2) {
            
            /// Progress View
            CircleArc(startAngle: geo.angles.start, endAngle: geo.angles.end, lineWidth: lineWidth)
                .frame(width: radius * 2, height: radius * 2)
                .foregroundColor(.gray)
                .overlay(
                    CircleArc(
                        startAngle: geo.progressAngles.start,
                        endAngle: geo.progressAngles.end,
                        lineWidth: lineWidth
                    ).foregroundColor(.blue)
                )
                .overlay(
                    CircleOnPerimeter(angle: geo.circleAngle, circleRadius: geo.indicatorRadius)
                        .foregroundColor(.green)
                )
                .overlay(
                    Image(systemName: "airplane")
                        .resizable()
                        .frame(maxWidth: geo.indicatorRadius, maxHeight: geo.indicatorRadius)
                        .rotationEffect(geo.circleAngle)
                        .foregroundColor(.red)
                        .offset(x: radius)
                        .rotationEffect(-geo.circleAngle)
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
    
    private func populateProgressGeometry() {
        DispatchQueue.main.async {
            self.geo = .init(
                progress: self.progress,
                radius: self.radius,
                angle1: self.angle1,
                angle2: self.angle2,
                lineWidth: self.lineWidth,
                rightToLeft: self.rightToLeft,
                offsetAngle: self.offsetAngle
            )
        }
    }
    
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  CircularProgressView
//
//  Created by Mahdi on 6/15/21.
//

import SwiftUI

struct ContentView: View {
    @State var radius: CGFloat = 150
    @State var degrees1: Double = 45
    @State var degrees2: Double = 135
    @State var width: CGFloat = 8
    var angles: (start: Double, end: Double) {
        (start: min(degrees1, degrees2), end: max(degrees1, degrees2))
    }
    var startAngle: Angle { .degrees(angles.start) }
    var endAngle: Angle { .degrees(angles.end) }
    
    @State var progress: CGFloat = 0.6 /* 0 <= progress <= 1 */
    var startOffset: CGFloat {
        ((.pi / 2) - startAngle.radians) / (2 * .pi)
    }
    var wholeArc: CGFloat {
        (2 * .pi) - (endAngle - startAngle).radians
    }
    var circleOffset: CGSize {
        let width = sin((2 * .pi * startOffset) + (wholeArc * progress)) * radius
        let height = cos((2 * .pi * startOffset) + (wholeArc * progress)) * radius
        return .init(width: width, height: height)
    }
    
    var body: some View {
        VStack {
            CircleArc(startAngle: startAngle, endAngle: endAngle, lineWidth: width)
                .frame(width: radius * 2, height: radius * 2)
                .foregroundColor(.blue)
                .overlay(
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: width * 4)
                        .offset(circleOffset)
                )
            
            VStack {
                Text("progress: \(progress)")
                Slider(value: $progress, in: 0...1)
                
                Text("start: \(degrees1)")
                Slider(value: $degrees1, in: 0...360)
                
                Text("end: \(degrees2)")
                Slider(value: $degrees2, in: 0...360)
                
                Text("width: \(width)")
                Slider(value: $width, in: 0...80)
            }
            .padding(.horizontal)
        }
    }
}

struct CircleArc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    var lineWidth: CGFloat = 8
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        path = path.strokedPath(.init(lineWidth: lineWidth, lineCap: .round))
        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

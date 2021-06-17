//
//  AppIconView.swift
//  CircularProgressView
//
//  Created by Mahdi
//

import SwiftUI

/// The view used to make the app's icon.
struct AppIconView: View {
    
    let radius = UIScreen.main.bounds.width * 2 / 5
    
    var body: some View {
        CircleArc.init(
            startAngle: .radians(-.pi / 5),
            endAngle: .radians(.pi * 6 / 5),
            lineWidth: 12
        )
            .foregroundColor(.gray)
            .frame(width: radius * 2, height: radius * 2)
            .overlay(
                CircleArc.init(
                    startAngle: .radians(-.pi / 5),
                    endAngle: .radians(.pi * 4 / 5),
                    lineWidth: 12
                )
                    .foregroundColor(.blue)
            )
            .overlay(
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.green)
                    .offset(x: radius)
                    .rotationEffect(-.radians(.pi * 4 / 5))
            )
            .overlay(
                Image(systemName: "airplane")
                    .resizable()
                    .frame(maxWidth: 20, maxHeight: 20)
                    .rotationEffect(.radians(.pi))
                    .foregroundColor(.red)
                    .offset(x: radius)
                    .rotationEffect(-.radians(.pi * 4 / 5))
            )
    }
}

// Preview Provider
struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
    }
}

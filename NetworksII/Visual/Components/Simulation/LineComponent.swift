//
//  LineComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct LineComponent: View {
    @ObservedObject var sender: Sender
    @State private var value = 1.0
    let geometry: GeometryProxy
    let numberSquares: Int

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: geometry.frame(in: .local).midX,
                                  y: geometry.frame(in: .local).midY))
            path.addLine(to: getCenter(geometry))
        }
        .stroke(self.sender.color, lineWidth: 2)
        .shadow(color: self.sender.color != .black ? self.sender.color.opacity(self.value) : .clear, radius: 3)
        .onChange(of: self.sender.color, perform: { newValue in
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                value = 0.5
            }
        })
    }

    private func getCenter(_ geo: GeometryProxy) -> CGPoint {
        let center = geo.frame(in: .local).midX * CGFloat((self.numberSquares + 1))
        let midPoint = CGPoint(x: geo.frame(in: .named("Custom")).midX, y: geo.frame(in: .named("Custom")).midY)
        let distX: CGFloat = self.getDistance(midPoint.x, center)
        let distY: CGFloat = self.getDistance(midPoint.y, center)
        let centerPoint = CGPoint(x: distX, y: distY)
        return centerPoint
    }

    private func getDistance(_ midPoint: CGFloat, _ center: CGFloat) -> CGFloat {
        var distance: CGFloat = 0
        if midPoint > center {
            distance -= (midPoint - center)
        } else if midPoint < center {
            distance += (center - midPoint)
        }
        return distance
    }
}

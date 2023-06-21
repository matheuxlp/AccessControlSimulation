//
//  LinesView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct LinesView: View {

    @Binding var connectedSenders: [Sender]
    let numberSquares: Int
    let geometry: GeometryProxy

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<self.numberSquares, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<self.numberSquares, id: \.self) { column in
                        let position: (Int, Int) = (row, column)
                        GeometryReader { geo in
                            if self.isEdge(row, column) {
                                if let sender = self.connectedSenders.first(where: {$0.position == position}) {
                                    LineComponent(sender: sender, geometry: geo, numberSquares: self.numberSquares)
                                }
                            }
                        }
                        .frame(size: geometry.size.height / CGFloat(self.numberSquares))
                    }
                }
            }
        }
        .coordinateSpace(name: "Custom")
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

    private func isEdge(_ row: Int, _ column: Int) -> Bool {
        return row == 0 || column == 0 || row == (self.numberSquares - 1) || column == (self.numberSquares - 1)
    }

    private func hasSender(_ position: (Int, Int)) -> Bool {
        return self.connectedSenders.contains(where: {$0.position == position})
    }

}



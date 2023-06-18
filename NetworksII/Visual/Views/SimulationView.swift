//
//  SimulationView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 12/06/23.
//

//ChannelView(size: self.getSize(geo), centerPoint: self.$centerPoint)
//SenderView(size: self.getSize(geo), centerPoint: self.$centerPoint)
import SwiftUI

struct SimulationView: View {

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray
                    .ignoresSafeArea()
                SimulationSquare()
                    .frame(size: geometry.size.height)
            }
        }
    }
}

struct SimulationSquare: View {

    @EnvironmentObject var simulation: Simulation
    @State var centerPoint: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinesView(geometry: geometry)
                SendersView(connectedSenders: self.$simulation.connectedSenders, channel: self.$simulation.channel, numberSquares: self.simulation.numberSquares, geometry: geometry)
            }
        }
        .border(.green)
        .padding(16)
    }
}

struct Computer {
    let position: (Int, Int)
}

struct LinesView: View {

    @EnvironmentObject var simulation: Simulation
    let geometry: GeometryProxy

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<self.simulation.numberSquares, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<self.simulation.numberSquares, id: \.self) { column in
                        GeometryReader { geo in
                            if row == 0 || row == simulation.numberSquares - 1 || column == 0 || column == simulation.numberSquares - 1 {
                                Path { path in
                                    path.move(to: CGPoint(x: geo.frame(in: .local).midX,
                                                          y: geo.frame(in: .local).midY))
                                    path.addLine(to: getCenter(geo))
                                }
                                //.stroke(self.simulation.connectedSenders.contains(where: {$0.position == (row, column)}) ? .yellow : .black, lineWidth: 3)
                            }
                        }
                        .frame(size: geometry.size.height / CGFloat(self.simulation.numberSquares))
                    }
                }
            }
        }
        .coordinateSpace(name: "Custom")
    }

    private func getCenter(_ geo: GeometryProxy) -> CGPoint {
        let center = geo.frame(in: .local).midX * CGFloat((self.simulation.numberSquares + 1))
        let midPoint = CGPoint(x: geo.frame(in: .named("Custom")).midX, y: geo.frame(in: .named("Custom")).midY)
        var distX: CGFloat = 0
        if midPoint.x > center {
            distX -= midPoint.x - center
        } else if midPoint.x < center {
            distX += center - midPoint.x
        }
        var distY: CGFloat = 0
        if midPoint.y > center {
            distY -= midPoint.y - center
        } else if midPoint.y < center {
            distY += center - midPoint.y
        }
        let centerPoint = CGPoint(x: distX, y: distY)
        return centerPoint
    }
}

struct ChannelView: View {

    let size: CGFloat

    var body: some View {
        VStack {
            Image(systemName: "circle.hexagongrid.circle")
                .font(.system(size: 48))
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.black)
                .padding(2)
                .background(Color.white)
                .clipShape(Circle())
        }
    }
}





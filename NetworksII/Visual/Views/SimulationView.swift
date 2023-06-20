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
                LinesView(connectedSenders: self.$simulation.connectedSenders, numberSquares: self.simulation.totalSenders, geometry: geometry)
                SendersView(connectedSenders: self.$simulation.connectedSenders, channel: self.$simulation.channel, numberSquares: self.simulation.totalSenders, geometry: geometry)
            }
        }
        .border(.green)
        .padding(16)
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





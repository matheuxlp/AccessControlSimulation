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

    @EnvironmentObject var simulation: Simulation

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.windowBackgroundColor)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            switch self.simulation.status {
                            case .running:
                                self.simulation.status = .paused
                            case .paused:
                                self.simulation.status = .running
                            }
                        } label: {
                            switch self.simulation.status {
                            case .running:
                                Text("Pause")
                            case .paused:
                                Text("Start")
                            }
                        }
                    }
                    Spacer()
                }
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





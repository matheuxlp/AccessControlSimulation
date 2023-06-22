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
        GeometryReader { outerGeometry in
            ZStack {
                Color(.windowBackgroundColor)
                    .ignoresSafeArea()
                GeometryReader { innerGeometry in
                    ZStack {
                        self.buildAreas(self.simulation.totalSenders, innerGeometry) {position in
                            self.buildLines(position)
                        }
                        self.buildAreas(self.simulation.totalSenders, innerGeometry) { position in
                            self.buildElements(position)
                        }
                    }
                }
                .padding(16)
                .frame(size: outerGeometry.size.height)
            }
        }
    }
}

extension Simulation {
    func isEdge(_ position: (Int, Int)) -> Bool {
        return position.0 == 0 || position.1 == 0 || position.0 == (self.totalSenders - 1) || position.1 == (self.totalSenders - 1)
    }

    func isMiddle(_ position: (Int, Int)) -> Bool {
        return position.0 == (self.totalSenders / 2) && position.1 == (self.totalSenders / 2)
    }

    func senderExists(_ position: (Int, Int)) -> Bool {
        return self.connectedSenders.contains(where: {$0.position == position})
    }

    func addSender(position: (Int, Int)) {
        withAnimation {
            self.connectedSenders.append(self.createSender(position))
            self.channel.connectSender(connectedSenders.last!)
        }
    }

    func createSender(_ position: (Int, Int)) -> Sender {
        var sensingTime = Double(Int.random(in: 1...10))
        if !self.connectedSenders.isEmpty {
            for sender in self.connectedSenders {
                if (sender.sensingTime - 1) == sensingTime {
                    sensingTime += 1
                }
            }
        }
        let dataSize = Double(Int.random(in: 1...20))
        return Sender(id: (self.connectedSenders.count + 1), position: position, sensingTime: sensingTime, dataSize: dataSize, maxAttempts: 5)
    }

    func removeSender(position: (Int, Int)) {
        withAnimation {
            if let index = self.connectedSenders.firstIndex(where: {$0.position == position}) {
                self.connectedSenders.remove(at: index)
                self.channel.disconnectSender(position)
            }
            if !connectedSenders.isEmpty {
                for index in 0..<connectedSenders.count {
                    self.connectedSenders[index].setId(index + 1)
                }
            }
        }
    }
}

extension SimulationView { // lines
    @ViewBuilder
    private func buildAreas<Content>(_ squares: Int, _ geometry: GeometryProxy, content: @escaping (_ position: (Int, Int)) -> Content) -> some View where Content: View {
        VStack(spacing: 0) {
            ForEach(0..<squares, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<squares, id: \.self) { column in
                        let position: (Int, Int) = (row, column)
                        content(position)
                        .frame(size: geometry.size.height / CGFloat(squares))
                    }
                }
            }
        }
        .coordinateSpace(name: "Custom")
    }

    @ViewBuilder
    private func buildLines(_ position: (Int, Int)) -> some View {
        GeometryReader { geo in
            if self.simulation.isEdge(position) {
                if let sender = self.simulation.connectedSenders.first(where: {$0.position == position}) {
                    LineComponent(sender: sender, geometry: geo, numberSquares: self.simulation.totalSenders)
                }
            }
        }
    }
}

extension SimulationView { // Senders & Channel
    @ViewBuilder
    private func buildElements(_ position: (Int, Int)) -> some View {
        if self.simulation.isMiddle(position) {
            if !self.simulation.channel.connectedSenders.isEmpty {
                ChannelComponent(channel: self.simulation.channel)
            } else {
                Text("a")
            }
        } else {
            self.buildSender(position)
        }
    }

    @ViewBuilder private func buildSender(_ position: (Int, Int)) -> some View {
        if self.simulation.isEdge(position) {
            if self.simulation.senderExists(position) {
                SenderSimulationComponent(sender: self.simulation.connectedSenders.first(where: {$0.position == position})!)
                    .onTapGesture {
                        if self.simulation.status != .running {
                            self.simulation.removeSender(position: position)
                        }
                    }
            } else {
                ZStack {
                    self.simulation.status == .running ? Color(.windowBackgroundColor) : Color.gray.opacity(0.2)
                    if self.simulation.status != .running {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 2)
                        VStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                            Text("Add Sender")
                        }
                    }
                }
                .padding(64)
                .onTapGesture {
                    if self.simulation.status != .running {
                        self.simulation.addSender(position: position)
                    }
                }
            }
        } else {
            Rectangle().fill(.clear)
        }
    }
}


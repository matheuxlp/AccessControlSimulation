//
//  SimulationView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 12/06/23.
//

//ChannelView(size: self.getSize(geo), centerPoint: self.$centerPoint)
//DeviceView(size: self.getSize(geo), centerPoint: self.$centerPoint)
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
                        self.buildAreas(self.simulation.totalDevices, innerGeometry) {position in
                            self.buildLines(position)
                        }
                        self.buildAreas(self.simulation.totalDevices, innerGeometry) { position in
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
        return position.0 == 0 || position.1 == 0 || position.0 == (self.totalDevices - 1) || position.1 == (self.totalDevices - 1)
    }

    func isMiddle(_ position: (Int, Int)) -> Bool {
        return position.0 == (self.totalDevices / 2) && position.1 == (self.totalDevices / 2)
    }

    func deviceExists(_ position: (Int, Int)) -> Bool {
        return self.connectedDevices.contains(where: {$0.position == position})
    }

    func addDevice(position: (Int, Int)) {
        withAnimation {
            self.connectedDevices.append(self.createDevice(position))
            self.channel.connectDevice(connectedDevices.last!)
        }
    }

    func createDevice(_ position: (Int, Int)) -> Device {
        var sensingTime = Double(Int.random(in: 1...10))
        if !self.connectedDevices.isEmpty {
            for device in self.connectedDevices {
                if (device.sensingTime - 1) == sensingTime {
                    sensingTime += 1
                }
            }
        }
        let dataSize = Double(Int.random(in: 1...20))
        return Device(id: (self.connectedDevices.count + 1), position: position, sensingTime: sensingTime, dataSize: dataSize, maxAttempts: 5)
    }

    func removeDevice(position: (Int, Int)) {
        withAnimation {
            if let index = self.connectedDevices.firstIndex(where: {$0.position == position}) {
                self.connectedDevices.remove(at: index)
                self.channel.disconnectDevice(position)
            }
            if !connectedDevices.isEmpty {
                for index in 0..<connectedDevices.count {
                    self.connectedDevices[index].setId(index + 1)
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
                if let device = self.simulation.connectedDevices.first(where: {$0.position == position}) {
                    LineComponent(device: device, geometry: geo, numberSquares: self.simulation.totalDevices)
                }
            }
        }
    }
}

extension SimulationView { // Devices & Channel
    @ViewBuilder
    private func buildElements(_ position: (Int, Int)) -> some View {
        if self.simulation.isMiddle(position) {
            if !self.simulation.channel.connectedDevices.isEmpty {
                ChannelComponent(channel: self.simulation.channel)
            } else {
                Text("a")
            }
        } else {
            self.buildDevice(position)
        }
    }

    @ViewBuilder private func buildDevice(_ position: (Int, Int)) -> some View {
        if self.simulation.isEdge(position) {
            if self.simulation.deviceExists(position) {
                DeviceSimulationComponent(device: self.simulation.connectedDevices.first(where: {$0.position == position})!)
                    .onTapGesture {
                        if self.simulation.status != .running {
                            self.simulation.removeDevice(position: position)
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
                            Text("Add Device")
                        }
                    }
                }
                .padding(64)
                .onTapGesture {
                    if self.simulation.status != .running {
                        self.simulation.addDevice(position: position)
                    }
                }
            }
        } else {
            Rectangle().fill(.clear)
        }
    }
}


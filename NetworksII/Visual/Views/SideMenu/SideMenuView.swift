//
//  SideMenuView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 12/06/23.
//

import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var simulation: Simulation
    var body: some View {
        ZStack {
            VisualEffectView(material: NSVisualEffectView.Material.contentBackground, blendingMode: NSVisualEffectView.BlendingMode.withinWindow)
            VStack {
                Button {
                    print(self.simulation.connectedDevices)
                } label: {
                    Text("Connected Devices")
                }
                Button {
                    withAnimation {
                        switch self.simulation.status {
                        case .running:
                            self.simulation.status = .paused
                        case .paused:
                            self.simulation.status = .running
                        }
                    }
                } label: {
                    switch self.simulation.status {
                    case .running:
                        Text("Pause")
                    case .paused:
                        Text("Start")
                    }
                }
                HStack {
                    Button {
                        self.simulation.changeSpeed(false)
                    } label: {
                        Text("-")
                    }
                    Text("\(self.simulation.speed, specifier: "%.1f")")
                    Button {
                        self.simulation.changeSpeed()
                    } label: {
                        Text("+")
                    }
                }
                // log
                VStack {
                    ZStack {
                        Color.clear
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(0..<self.simulation.infomationLog.count, id: \.self) { index in
                                    Text("\(self.simulation.infomationLog[index])")
                                }
                            }
                        }
                    }
                }
                .border(.red)
            }
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

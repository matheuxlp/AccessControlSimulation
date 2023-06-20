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
                    print(self.simulation.connectedSenders)
                } label: {
                    Text("Connected Senders")
                }
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

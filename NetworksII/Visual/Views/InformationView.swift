//
//  InformationView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 15/06/23.
//

import SwiftUI

struct InformationView: View {
    @EnvironmentObject var simulation: Simulation

    var body: some View {
        ZStack {
            Color.pink
                .ignoresSafeArea()
            VStack {
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

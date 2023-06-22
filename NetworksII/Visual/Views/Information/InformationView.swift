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
        GeometryReader { geometry in
            ZStack {
                Color(.controlBackgroundColor)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    ChannelInformationComponent(channel: self.simulation.channel)
                        .padding(.bottom, 8)
                    ScrollView {
                        if self.simulation.connectedDevices.isEmpty {
                            ZStack {
                                Color.clear
                            }
                        } else {
                            ForEach(0..<self.simulation.connectedDevices.count, id: \.self) { index in
                                DeviceInformationComponent(device: self.simulation.connectedDevices[index])
                                    .padding(.horizontal, 16)
                            }
                        }
                        
                    }
                }
            }
        }
    }
}




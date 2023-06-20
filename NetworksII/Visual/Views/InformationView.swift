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
                ChannelInformationView(channel: self.simulation.channel)
                ForEach(Array(stride(from: 0, to: self.simulation.connectedSenders.count, by: 2)), id: \.self) { index in
                    HStack {
                        SenderInformationView(sender: self.simulation.connectedSenders[index])
                        if self.simulation.connectedSenders.count > (index + 1) {
                            SenderInformationView(sender: self.simulation.connectedSenders[index + 1])
                        }
                    }
                }
                Spacer()
            }
        }
    }
}


struct SenderInformationView: View {
    @ObservedObject var sender: Sender

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "display")
                .font(.system(size: 32))
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.black)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
            Text("Status: \(self.sender.status.rawValue)")
            Text("Sensing Time: \(sender.sensingTime, specifier: "%.0f")")
            Text("Data Size: \(sender.dataSize, specifier: "%.0f")")
        }
    }
}

struct ChannelInformationView: View {
    @ObservedObject var channel: TransmissionChannel

    var body: some View {
        HStack {
            VStack {
                Image(systemName: "display")
                    .font(.system(size: 32))
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                Text("Status: \(self.channel.status.rawValue)")
            }
            Spacer()
        }
        .padding(16)
        .border(.black)
    }
}

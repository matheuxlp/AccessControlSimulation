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
                Color.pink
                    .ignoresSafeArea()
                VStack {
                    ChannelInformationView(channel: self.simulation.channel)
                    ScrollView {
                        ForEach(Array(stride(from: 0, to: self.simulation.connectedSenders.count, by: 2)), id: \.self) { index in
                            HStack(spacing: 0) {
                                SenderInformationView(sender: self.simulation.connectedSenders[index])
                                    .frame(width: geometry.frame(in: .local).width / 2)
                                if self.simulation.connectedSenders.count > (index + 1) {
                                    SenderInformationView(sender: self.simulation.connectedSenders[index + 1])
                                } else {
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


struct SenderInformationView: View {
    @ObservedObject var sender: Sender

    var body: some View {
        ZStack {
            Color.clear
            VStack(alignment: .leading) {
                Text("Sender #\(sender.id)")
                Image(systemName: "display")
                    .font(.system(size: 32))
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                Text("Status: \(self.sender.status.rawValue) | (\(self.sender.control, specifier: "%.0f"))")
                Text("Sensing Time: \(sender.sensingTime, specifier: "%.0f")")
                Text("Data Size: \(sender.dataSize, specifier: "%.0f")")
            }
        }
        .padding(16)
        .border(.black)
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
            if let info = self.channel.channelInfo {
                Text("\(info)")
            }
            Spacer()
        }
        .padding(16)
        .border(.black)
    }
}

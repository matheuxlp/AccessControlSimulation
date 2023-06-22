//
//  ChannelInformationComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct ChannelInformationComponent: View {
    @ObservedObject var channel: TransmissionChannel

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                ChannelComponent(channel: self.channel)
            }
            VStack(alignment: .leading) {
                Text("CHANNEL STATUS: \(self.channel.status.rawValue)")
                    .bold()
                HStack {
                    if let firstInfo = self.channel.channelInfo.0 {
                        Text("\(firstInfo)")
                    }
                    if let secondInfo = self.channel.channelInfo.1 {
                        Text("\(secondInfo)")
                            .bold()
                    }
                }
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        .padding(16)
    }
}



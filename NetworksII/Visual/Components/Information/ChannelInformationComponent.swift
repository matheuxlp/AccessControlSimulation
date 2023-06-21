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



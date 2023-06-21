//
//  ChannelComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct ChannelComponent: View {
    
    @State private var value = 0.7
    @ObservedObject var channel: TransmissionChannel

    var body: some View {
        VStack {
            Image(systemName: "circle.hexagongrid.circle")
                .font(.system(size: 48))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white.opacity(0.75), self.channel.color)
        }
        .padding(-4)
        .background(Color(.windowBackgroundColor))
        .clipShape(Circle())
        .overlay(Circle().stroke(.clear, lineWidth: 2))
        .shadow(color: self.channel.color != .black ? self.channel.color.opacity(self.value) : .clear, radius: 3)
        .onChange(of: self.channel.color, perform: { _ in
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                value = 0.3
            }
        })
    }
}

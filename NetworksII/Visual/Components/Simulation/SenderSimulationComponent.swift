//
//  SenderSimulationComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct SenderSimulationComponent: View {
    @State private var value = 0.7
    @ObservedObject var sender: Sender

    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "circle.dashed.inset.filled")
                    .font(.system(size: 48))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(self.sender.status == .waitingForData ? Color(.windowBackgroundColor) : .white.opacity(0.75), self.sender.color)
                    .background(content: {
                        if self.sender.color != .black {
                            self.sender.color.opacity(self.value)
                        }
                    })
                    .onChange(of: self.sender.color, perform: { newValue in
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            value = 0.3
                        }
                    })
                Text("#\(self.sender.id)")
                    .foregroundColor(self.sender.status == .waitingForData ? . white.opacity(0.9) : .black)
            }
        }
        .padding(-4)
        .background(Color(.windowBackgroundColor))
        .clipShape(Circle())
        .overlay(Circle().stroke(.clear, lineWidth: 2))
        .shadow(color: self.sender.color != .black ? self.sender.color.opacity(self.value) : .clear, radius: 3)
    }
}

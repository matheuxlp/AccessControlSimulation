//
//  DeviceSimulationComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct DeviceSimulationComponent: View {
    @State private var value = 0.7
    @ObservedObject var device: Device

    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "circle.dashed.inset.filled")
                    .font(.system(size: 48))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(self.device.status == .waitingForData ? Color(.windowBackgroundColor) : .white.opacity(0.75), self.device.color)
                    .background(content: {
                        if self.device.color != .black {
                            self.device.color.opacity(self.value)
                        }
                    })
                    .onChange(of: self.device.color, perform: { newValue in
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            value = 0.3
                        }
                    })
                Text("#\(self.device.id)")
                    .foregroundColor(self.device.status == .waitingForData ? . white.opacity(0.9) : .black)
            }
        }
        .padding(-4)
        .background(Color(.windowBackgroundColor))
        .clipShape(Circle())
        .overlay(Circle().stroke(.clear, lineWidth: 2))
        .shadow(color: self.device.color != .black ? self.device.color.opacity(self.value) : .clear, radius: 3)
    }
}

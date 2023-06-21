//
//  SenderInformationComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct SenderInformationComponent: View {
    @ObservedObject var sender: Sender

    var body: some View {
        ZStack {
            Color.gray.opacity(0.75)
            self.sender.color.opacity(0.25)
            HStack {
                VStack(alignment: .leading) {
                    Image(systemName: "circle.dashed")
                        .font(.system(size: 32))
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(self.sender.color, lineWidth: 2))
                    Text("Sender #\(sender.id)")
                }
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Status: \(self.sender.status.rawValue) | (\(self.sender.timeRemaning, specifier: "%.0f"))")
                    Text("Sensing time: \(sender.sensingTime, specifier: "%.0f")")
                    Text("Data size: \(sender.dataSize, specifier: "%.0f")")
                    Text("Time for new data: \(sender.timeForNewData, specifier: "%.0f")")
                }
                Spacer()
            }
            .padding(8)
        }
        .cornerRadius(8)
        .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 2)
            )
    }
}

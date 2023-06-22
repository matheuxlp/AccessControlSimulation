//
//  SenderInformationComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct SenderInformationComponent: View {
    @ObservedObject var sender: Sender
    @State var expanded: Bool = false
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
                if self.expanded {
                    self.buildEditable()
                } else {
                    self.buildInformation()
                }
                Spacer()
            }
            .padding(8)
            self.buildEditButton()
        }
        .cornerRadius(8)
        .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 2)
            )
    }

    @ViewBuilder
    private func buildEditButton() -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        self.expanded.toggle()
                    }
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)

            }
            Spacer()
        }
        .padding(8)
    }

    @ViewBuilder
    private func buildInformation() -> some View  {
        VStack(alignment: .leading) {
            Spacer()
            Text("Status: \(self.sender.status.rawValue) | (\(self.sender.timeRemaning, specifier: "%.0f"))")
            Text("Sensing time: \(sender.sensingTime, specifier: "%.0f")")
            Text("Data size: \(sender.dataSize, specifier: "%.0f")")
            Text("Time for new data: \(sender.timeForNewData, specifier: "%.0f")")
        }
    }

    @ViewBuilder
    private func buildEditable() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("Sensing time: \(self.sender.sensingTime, specifier: "%.0f")")
                TextField("", value: self.$sender.sensingTime, format: .number)
                Spacer()
            }
            HStack {
                Text("Data size: \(self.sender.dataSize, specifier: "%.0f")")
                TextField("", value: self.$sender.dataSize, format: .number)
                Spacer()
            }
            HStack {
                Text("Random Backoff:")
                withAnimation {
                    Toggle("", isOn: self.$sender.randonBackoff)
                }
                Spacer()
            }
            if !self.sender.randonBackoff {
                HStack {
                    Text("Backoff:")
                    TextField("", value: self.$sender.definedBackoff, format: .number)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)

    }
}

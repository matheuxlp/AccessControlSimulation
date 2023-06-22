//
//  DeviceInformationComponent.swift
//  NetworksII
//
//  Created by Matheus Polonia on 20/06/23.
//

import SwiftUI

struct DeviceInformationComponent: View {
    @ObservedObject var device: Device
    @State var expanded: Bool = false
    var body: some View {
        ZStack {
            Color.gray.opacity(0.75)
            self.device.color.opacity(0.25)
            HStack(spacing: 16) {
                VStack(alignment: .center) {
                    Text("Device #\(device.id)")
                        .bold()
                    DeviceSimulationComponent(device: device)
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
            //Spacer()
            switch self.device.status {
            case .backoff:
                Text("BACKOFF")
                    .bold()
                Text("Backoff period: \(self.device.currentBackoff ?? 0, specifier: "%.0f")TU")
                Text("Current attempt: \(self.device.currentAttempt, specifier: "%.0f")")
                Spacer()
                HStack {
                    Spacer()
                    Text("TR: \(self.device.timeRemaining, specifier: "%.0f")TU")
                }
                //Text("Time remaining: \(self.device.timeRemaining, specifier: "%.0f")TU")
            case .sensingChannel:
                Text("SENSING")
                    .bold()
                Text("Sensing period: \(self.device.sensingTime, specifier: "%.0f")TU")
                Spacer()
                HStack {
                    Spacer()
                    Text("TR: \(self.device.timeRemaining, specifier: "%.0f")TU")
                }
                //Text("Time remaining: \(self.device.timeRemaining, specifier: "%.0f")TU")
            case .sendingData:
                Text("SENDING DATA")
                    .bold()
                Text("Data size: \(self.device.dataSize, specifier: "%.0f")TU")
                Spacer()
                HStack {
                    Spacer()
                    Text("TR: \(self.device.timeRemaining, specifier: "%.0f")TU")
                }
            case .waitingForData:
                Text("WAITING FOR NEW DATA")
                    .bold()
                Text("Wait period: \(self.device.timeForNewData, specifier: "%.0f")TU")
                Spacer()
                HStack {
                    Spacer()
                    Text("TR: \(self.device.timeRemaining, specifier: "%.0f")TU")
                }
            case .canSendData:
                VStack {
                    Text("CHANNEL FREE, CAN SEND DATA")
                        .bold()
                }
            case .channelCrash:
                VStack {
                    Text("CHANNEL FREE, CAN SEND DATA")
                        .bold()
                }
            default:
                EmptyView()
            }
        }
        .padding(.trailing, 16)
    }

    @ViewBuilder
    private func buildEditable() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text("Sensing time: \(self.device.sensingTime, specifier: "%.0f")")
                TextField("", value: self.$device.sensingTime, format: .number)
                Spacer()
            }
            HStack {
                Text("Data size: \(self.device.dataSize, specifier: "%.0f")")
                TextField("", value: self.$device.dataSize, format: .number)
                Spacer()
            }
            HStack {
                Text("Random Backoff:")
                withAnimation {
                    Toggle("", isOn: self.$device.randonBackoff)
                }
                Spacer()
            }
            if !self.device.randonBackoff {
                HStack {
                    Text("Backoff:")
                    TextField("", value: self.$device.definedBackoff, format: .number)
                    Spacer()
                }
            }
        }
        .padding(.trailing, 16)

    }
}

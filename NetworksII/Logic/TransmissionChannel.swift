//
//  TransmissionChannel.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import Foundation
import SwiftUI


final class TransmissionChannel: ObservableObject {
    @Published var status: ChannelStatus = ChannelStatus.free
    @Published var connectedDevices: [Device] = []
    @Published var channelInfo: (String?, String?)
    @Published var color: Color = .black
    var recivingFrom: [Int] = []
    var hasCrash: Bool = false

    func connectDevice(_ device: Device) {
        device.delegate = self
        self.connectedDevices.append(device)
    }

    func disconnectDevice(_ position: (Int, Int)) {
        if let index = self.connectedDevices.firstIndex(where: {$0.position == position}) {
            self.connectedDevices.remove(at: index)
        }
    }

    func checkStatus() {
        if self.recivingFrom.isEmpty {
            self.color = .gray
        } else if self.recivingFrom.count > 1 {
            let channalDataDict:[String: [Int]] = ["data": self.recivingFrom]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CrashIdentified"), object: nil, userInfo: channalDataDict)
            self.channelInfo = (nil, nil)
            self.recivingFrom = []
            self.status = .free
            self.color = .gray
        }
    }
}

extension TransmissionChannel {
    func reset() {
        self.connectedDevices = []
        self.recivingFrom = []
        self.status = .free
        self.hasCrash = false
        self.color = .black
        self.channelInfo = (nil, nil)
    }

    func hasDevices() -> Bool {
        return !self.connectedDevices.isEmpty
    }
}

extension TransmissionChannel: DeviceDelegate {
    func dataSent(_ id: Int, _ time: ContinuousClock.Instant) {
        self.channelInfo.0 = "All data from:"
        self.channelInfo.1 = "Device #\(id)"
        self.status = .free
        self.recivingFrom = []
        self.color = .gray
        self.channelInfo = (nil, nil)
    }

    func sendData(_ id: Int, _ time: ContinuousClock.Instant) {
        self.channelInfo.0 = "Recived data from:"
        self.channelInfo.1 = "Device #\(id)"
    }

    func startedToSendData(_ id: Int) {
        self.channelInfo.0 = "Device #\(id), started to send data."
        self.status = .occupied
        self.recivingFrom.append(id)
        self.color = .green
        NotificationCenter.default.post(name: Notification.Name("Device\(id)CanSend"), object: nil)
    }
}

enum ChannelStatus: String {
    case free = "Free"
    case occupied = "Occupied"
}

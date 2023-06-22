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
    @Published var channelInfo: String?
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
        if self.recivingFrom.count > 1 {
            let channalDataDict:[String: [Int]] = ["data": self.recivingFrom]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CrashIdentified"), object: nil, userInfo: channalDataDict)
            self.recivingFrom = []
            self.status = .free
            self.color = .black
        }
    }
}

extension TransmissionChannel: DeviceDelegate {
    func dataSent(_ id: Int, _ time: ContinuousClock.Instant) {
        //print("All data from: Device #\(id) sent | TS: \(time)")
        self.channelInfo = "All data from: Device #\(id)"
        self.status = .free
        self.recivingFrom = []
        self.color = .black
    }

    func sendData(_ id: Int, _ time: ContinuousClock.Instant) {
        self.channelInfo = "Recived data from: Device #\(id)"
        //print("Recived data from: Device #\(id) | TS: \(time)")
    }

    func startedToSendData(_ id: Int) {
        self.channelInfo = "Device #\(id), started to send data."
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

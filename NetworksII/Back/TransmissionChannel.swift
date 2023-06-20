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
    @Published var connectedSenders: [Sender] = []
    @Published var channelInfo: String?
    var recivingFrom: [Int] = []
    var hasCrash: Bool = false

    func connectSender(_ sender: Sender) {
        sender.delegate = self
        self.connectedSenders.append(sender)
    }

    func checkStatus() {
        if self.recivingFrom.count > 1 {
            NotificationCenter.default.post(name: Notification.Name("CrashIdentified"), object: nil)
            self.recivingFrom = []
            self.status = .free
        }
    }
}

extension TransmissionChannel: SenderDelegate {
    func dataSent(_ id: Int, _ time: ContinuousClock.Instant) {
        //print("All data from: Sender #\(id) sent | TS: \(time)")
        self.channelInfo = "All data from: Sender #\(id)"
        self.status = .free
        self.recivingFrom = []
    }

    func sendData(_ id: Int, _ time: ContinuousClock.Instant) {
        self.channelInfo = "Recived data from: Sender #\(id)"
        //print("Recived data from: Sender #\(id) | TS: \(time)")
    }

    func startedToSendData(_ id: Int) {
        print("Sender #\(id), started to send data.")
        print(status)
        self.channelInfo = "Sender #\(id), started to send data."
        self.status = .occupied
        self.recivingFrom.append(id)
        NotificationCenter.default.post(name: Notification.Name("Sender\(id)CanSend"), object: nil)
    }
}

enum ChannelStatus: String {
    case free = "Free"
    case occupied = "Occupied"
}

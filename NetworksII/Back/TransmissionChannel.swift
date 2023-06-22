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
    @Published var color: Color = .black
    var recivingFrom: [Int] = []
    var hasCrash: Bool = false

    func connectSender(_ sender: Sender) {
        sender.delegate = self
        self.connectedSenders.append(sender)
    }

    func disconnectSender(_ position: (Int, Int)) {
        if let index = self.connectedSenders.firstIndex(where: {$0.position == position}) {
            self.connectedSenders.remove(at: index)
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

extension TransmissionChannel: SenderDelegate {
    func dataSent(_ id: Int, _ time: ContinuousClock.Instant) {
        //print("All data from: Sender #\(id) sent | TS: \(time)")
        self.channelInfo = "All data from: Sender #\(id)"
        self.status = .free
        self.recivingFrom = []
        self.color = .black
    }

    func sendData(_ id: Int, _ time: ContinuousClock.Instant) {
        self.channelInfo = "Recived data from: Sender #\(id)"
        //print("Recived data from: Sender #\(id) | TS: \(time)")
    }

    func startedToSendData(_ id: Int) {
        self.channelInfo = "Sender #\(id), started to send data."
        self.status = .occupied
        self.recivingFrom.append(id)
        self.color = .green
        NotificationCenter.default.post(name: Notification.Name("Sender\(id)CanSend"), object: nil)
    }
}

enum ChannelStatus: String {
    case free = "Free"
    case occupied = "Occupied"
}

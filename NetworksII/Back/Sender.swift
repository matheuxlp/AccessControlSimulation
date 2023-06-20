//
//  Sender.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import Foundation
import SwiftUI

protocol SenderDelegate: AnyObject {
    func startedToSendData(_ id: Int)
    func sendData(_ id: Int, _ time: ContinuousClock.Instant)
    func dataSent(_ id: Int, _ time: ContinuousClock.Instant)
}

final class Sender: ObservableObject, Identifiable {

    var id: Int
    var position: (Int, Int)

    @Published var control: Double = 0
    @Published var sensingTime: Double
    @Published var dataSize: Double
    @Published var crash: Bool = false

    // BACKOFF
    @Published var currentAttempt: Int = 0
    @Published var maxAttempts: Int
    @Published var backoff: Double?

    @Published var color: Color = .black

    //DELEGATE
    weak var delegate: SenderDelegate?


    // INFOMRATION
    @Published var senderInfo: (String?, String?)


    @Published var status: SenderStatus = SenderStatus.cantSendData

    let clock = ContinuousClock()

    init(id: Int, position: (Int, Int), sensingTime: Double, dataSize: Double, maxAttempts: Int) {
        self.id = id
        self.position = position
        self.sensingTime = sensingTime
        self.dataSize = dataSize
        self.maxAttempts = maxAttempts
        NotificationCenter.default.addObserver(self, selector: #selector(self.recivedCrash(notification:)), name: Notification.Name("CrashIdentified"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.recivedCanSend(notification:)), name: Notification.Name("Sender\(id)CanSend"), object: nil)
    }

    public func run(_ channel: TransmissionChannel) {
        switch self.status {
        case .sensingChannel:
            self.senseChannel(channel)
        case .sendingData:
            self.sendData()
        case .canSendData:
            self.delegate?.startedToSendData(self.id)
        case .cantSendData:
            self.status = .sensingChannel
        case .channelCrash:
            self.senderInfo.0 = "Channel Crash"
            self.status = .backoff
        case .backoff:
            self.performBackoff()
        }
        self.setColor()
    }

    func setId(_ id: Int) {
        self.id = id
    }

    func performBackoff() {
        if self.backoff == nil {
            self.control = 0
            self.backoff = self.getBackoffTime()
        } else if self.currentAttempt == self.maxAttempts {
            self.currentAttempt = 0
            self.backoff = nil
            return
        }
        if self.control == self.backoff {
            self.control = 0
            self.currentAttempt += 1
            self.backoff = nil
            self.status = .sensingChannel
        } else {
            self.control += 1
        }
    }

    func getBackoffTime() -> TimeInterval {
        let backoffTime = Int(pow(2.0, Double(self.currentAttempt)))
        return Double(backoffTime)
    }

    func senseChannel(_ channel: TransmissionChannel) {
        self.senderInfo.0 = "Sensing channel..."
        self.control += 1
        if channel.status == .occupied {
            self.senderInfo.0 = "Channel Occupied!"
            self.status = .sensingChannel
            self.control = 0
        } else {
            if self.control == self.sensingTime {
                self.senderInfo.0 = "Can send Data!"
                self.status = .canSendData
                self.control = 0
            } else {
                self.senderInfo.0 = "Channel free!"
            }
        }
    }

    func sendData() {
        self.control += 1
        self.senderInfo.0 = "Sending data..."
        self.delegate?.sendData(self.id, clock.now)
        if self.control == self.dataSize {
            self.senderInfo.0 = "Data sent!"
            self.delegate?.dataSent(self.id, clock.now)
            self.status = .sensingChannel
            self.control = 0
        }
    }

    func setColor() {
        switch self.status {
        case .sensingChannel:
            color = .cyan
        case .sendingData:
            color = .green
        case .canSendData:
            color = .green
        case .cantSendData:
            color = .black
        case .channelCrash:
            color = .red
        case .backoff:
            color = .black
        }
    }

    @objc func recivedCrash(notification: Notification) {
        self.status = .channelCrash
    }

    @objc func recivedCanSend(notification: Notification) {
        self.status = .sendingData
    }

}

enum SenderStatus: String {
    case sensingChannel = "Sensing"
    case sendingData = "Sending data"
    case canSendData = "Can send data"
    case cantSendData = "Can't send data"
    case channelCrash = "Crash"
    case backoff = "Backoff"
}

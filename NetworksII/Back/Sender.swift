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
    @Published var color: Color = .black
    @Published var status: SenderStatus = SenderStatus.cantSendData
    @Published var timeRemaning: Double = 0
    @Published var timeForNewData: Double = 0
    @Published var randonBackoff: Bool = true
    @Published var definedBackoff: Double = 0

    // BACKOFF
    @Published var currentAttempt: Int = 0
    @Published var maxAttempts: Int
    @Published var initialBackoff: Double?
    @Published var currentbackoff: Double?

    //DELEGATE
    weak var delegate: SenderDelegate?

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
            self.status = .backoff
        case .backoff:
            self.performBackoff()
        case .waitingForData:
            self.waitForData()
        }
        self.setColor()
        setTimeRemaining()
    }

    func setId(_ id: Int) {
        self.id = id
    }

    func setTimeRemaining() {
        switch self.status {
        case .backoff:
            if let backoff = self.currentbackoff {
                self.timeRemaning = backoff - control
            }
        case .sensingChannel:
            self.timeRemaning = self.sensingTime - self.control
        case .sendingData:
            self.timeRemaning = self.dataSize - self.control
        case .waitingForData:
            self.timeRemaning = self.timeForNewData - self.control
        default:
            self.timeRemaning = 0
        }
    }

    func waitForData() {
        if self.timeForNewData == self.control {
            self.timeForNewData = 0
            self.control = 0
            self.status = .sensingChannel
        } else {
            self.control += 1
        }
    }

    func performBackoff() {
        if self.initialBackoff == nil {
            if self.randonBackoff {
                self.initialBackoff = Double(Int.random(in: 0...5))
            } else {
                self.initialBackoff = self.definedBackoff
            }
            self.currentbackoff = self.initialBackoff
            self.control = 0
        } else if self.currentbackoff == nil {
            self.currentbackoff = self.getBackoffTime()
        } else if self.currentAttempt == self.maxAttempts {
            self.currentAttempt = 0
            self.initialBackoff = nil
            self.currentbackoff = nil
            return
        }
        if self.control == self.currentbackoff {
            self.control = 0
            self.currentAttempt += 1
            self.currentbackoff = nil
            self.status = .sensingChannel
        } else {
            self.control += 1
            self.setTimeRemaining()
        }
    }

    func getBackoffTime() -> TimeInterval {
        var backoff: Double = self.initialBackoff!
        for _ in 0..<currentAttempt {
            backoff = backoff * self.initialBackoff!
        }
        return backoff
    }

    func senseChannel(_ channel: TransmissionChannel) {
        self.control += 1
        if channel.status == .occupied {
            self.status = .sensingChannel
            self.control = 0
        } else {
            if self.control == self.sensingTime {
                self.status = .canSendData
                self.control = 0
            } else {
            }
        }
    }

    func sendData() {
        self.control += 1
        self.delegate?.sendData(self.id, clock.now)
        if self.control == self.dataSize {
            self.delegate?.dataSent(self.id, clock.now)
            self.status = .waitingForData
            self.control = 0
            self.timeForNewData = Double(Int.random(in: 1...10))
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
            color = .gray
        case .channelCrash:
            color = .red
        case .backoff:
            color = .gray
        case .waitingForData:
            color = .purple
        }
    }

    @objc func recivedCrash(notification: Notification) {
        self.status = .channelCrash
        if let data = notification.userInfo?["data"] as? [Int] {
            if data.contains(self.id) {
                self.color = .red
            } else {
                self.color = .gray
            }
        } else {
            self.color = .gray
        }
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
    case waitingForData = "Waiting for data"
}

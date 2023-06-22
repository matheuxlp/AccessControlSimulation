//
//  Device.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import Foundation
import SwiftUI

protocol DeviceDelegate: AnyObject {
    func startedToSendData(_ id: Int)
    func sendData(_ id: Int, _ time: ContinuousClock.Instant)
    func dataSent(_ id: Int, _ time: ContinuousClock.Instant)
}

final class Device: ObservableObject, Identifiable {

    var id: Int
    var position: (Int, Int)

    @Published var control: Double = 0
    @Published var sensingTime: Double
    @Published var dataSize: Double
    @Published var crash: Bool = false
    @Published var color: Color = .black
    @Published var status: DeviceStatus = DeviceStatus.cantSendData
    @Published var timeRemaining: Double = 0
    @Published var timeForNewData: Double = 0
    @Published var waitForNewData: Bool = true

    // BACKOFF
    @Published var currentAttempt: Int = 0
    @Published var maxAttempts: Int
    @Published var initialBackoff: Double?
    @Published var currentBackoff: Double?
    @Published var randonBackoff: Bool = true
    @Published var definedBackoff: Double = 0

    //DELEGATE
    weak var delegate: DeviceDelegate?

    let clock = ContinuousClock()

    init(id: Int, position: (Int, Int), sensingTime: Double, dataSize: Double, maxAttempts: Int) {
        self.id = id
        self.position = position
        self.sensingTime = sensingTime
        self.dataSize = dataSize
        self.maxAttempts = maxAttempts
        NotificationCenter.default.addObserver(self, selector: #selector(self.recivedCrash(notification:)), name: Notification.Name("CrashIdentified"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.recivedCanSend(notification:)), name: Notification.Name("Device\(id)CanSend"), object: nil)
    }
}

extension Device { // logic
    public func run(_ channel: TransmissionChannel) {
        withAnimation {
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
            self.setTimeRemaining()
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

    func senseChannel(_ channel: TransmissionChannel) {
        self.control += 1
        if channel.status == .occupied {
            self.status = .sensingChannel
            self.control = 0
            // Reset Backoff
            self.initialBackoff = nil
            self.currentBackoff = nil
            self.currentAttempt = 0
        } else {
            if self.control == self.sensingTime {
                self.status = .canSendData
                self.control = 0
            }
        }
    }

    func sendData() {
        self.control += 1
        self.delegate?.sendData(self.id, clock.now)
        if self.control == self.dataSize {
            self.delegate?.dataSent(self.id, clock.now)
            self.control = 0
            if self.waitForNewData {
                self.timeForNewData = Double(Int.random(in: 1...10))
                self.status = .waitingForData
            } else {
                self.status = .sendingData
            }
        }
        if self.initialBackoff == nil {
            // Reset Backoff
            self.initialBackoff = nil
            self.currentBackoff = nil
            self.currentAttempt = 0
        }
    }
}

extension Device { // backgoff

    func performBackoff() {
        if self.initialBackoff == nil {
            self.initialBackoff = self.randonBackoff ? Double(Int.random(in: 0...5)) : self.definedBackoff
            self.currentBackoff = self.initialBackoff
            self.control = 0
        } else if self.currentBackoff == nil {
            self.currentBackoff = self.getBackoffTime()
        } else if self.currentAttempt == self.maxAttempts {
            self.currentAttempt = 0
            self.initialBackoff = nil
            self.currentBackoff = nil
            return
        }
        if self.control == self.currentBackoff {
            self.control = 0
            self.currentAttempt += 1
            self.currentBackoff = nil
            self.status = .sensingChannel
        } else {
            self.control += 1
            self.setTimeRemaining()
        }
    }


    func getBackoffTime() -> TimeInterval {
        guard let initialBackoff = self.initialBackoff else {
            return 0.0
        }
        var backoff: Double = initialBackoff
        for _ in 0..<currentAttempt {
            backoff *= initialBackoff
        }
        return backoff
    }
}

extension Device { // visual

    func setTimeRemaining() {
        switch status {
        case .backoff:
            if let currentBackoff = currentBackoff {
                timeRemaining = currentBackoff - control
            }
        case .sensingChannel:
            timeRemaining = sensingTime - control
        case .sendingData:
            timeRemaining = dataSize - control
        case .waitingForData:
            timeRemaining = timeForNewData - control
        default:
            timeRemaining = 0
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

}

extension Device {
    func setId(_ id: Int) {
        self.id = id
    }

    func restart() {
        self.control = 0
        self.status = .cantSendData
        self.currentAttempt = 0
        self.initialBackoff = nil
        self.currentBackoff = nil
        self.color = .black
        self.randonBackoff = true
        self.timeRemaining = 0
        self.timeForNewData = 0
        self.randonBackoff = true
        self.definedBackoff = 0
        self.waitForNewData = true
    }
}

extension Device { // notification
    @objc func recivedCrash(notification: Notification) {
        withAnimation {
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
    }

    @objc func recivedCanSend(notification: Notification) {
        withAnimation {
            self.status = .sendingData
        }
    }
}

enum DeviceStatus: String {
    case sensingChannel = "Sensing"
    case sendingData = "Sending data"
    case canSendData = "Can send data"
    case cantSendData = "Can't send data"
    case channelCrash = "Crash"
    case backoff = "Backoff"
    case waitingForData = "Waiting for data"
}

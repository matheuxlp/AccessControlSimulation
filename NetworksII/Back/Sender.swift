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

    // BACKOFF
    @Published var currentAttempt: Int = 0
    @Published var maxAttempts: Int
    @Published var backoff: Double?

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
            self.timeRemaning = self.backoff ?? 0 - self.control
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

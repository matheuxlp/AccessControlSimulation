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

    let id: Int

    @Published var control: Double = 0
    @Published var sensingTime: Double
    @Published var dataSize: Double
    @Published var crash: Bool = false

    // BACKOFF
    @Published var currentAttempt: Int = 0
    @Published var maxAttempts: Int
    @Published var backoff: Double?

    //DELEGATE
    weak var delegate: SenderDelegate?


    // INFOMRATION
    @Published var senderInfo: (String?, String?)


    var status: SenderStatus = SenderStatus.cantSendData

    let clock = ContinuousClock()

    init(id: Int = 1, sensingTime: Double = 3, dataSize: Double = 4, maxAttempts: Int = 5) {
        self.id = id
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
            self.backoff = nil
            self.delegate?.startedToSendData(self.id)
        case .cantSendData:
            self.status = .sensingChannel
        case .channelCrash:
            //print("Channel Crash")
            self.senderInfo.0 = "Channel Crash"
            self.status = .backoff
        case .backoff:
            self.performBackoff()
        }
    }

    func performBackoff() {
        // Backoff starts
        if self.backoff == nil {
            self.senderInfo.0 = "Start Backoff"
            self.currentAttempt = 1
            self.control = 0
            self.backoff = self.getBackoffTime()
        } else {
            self.currentAttempt += 1
            if self.currentAttempt == self.maxAttempts {
                self.senderInfo.0 = "Reseting Backoff"
                self.backoff = nil
            } else {
                self.control += 1
                if self.control == self.backoff {
                    self.senderInfo.0 = "Backoff ended"
                    self.status = .sensingChannel
                    self.control = 0
                }
            }
        }

    }

    func getBackoffTime() -> TimeInterval {
        let backoffTime = Int(pow(2.0, Double(currentAttempt)))
        //print("backoffTime \(backoffTime)")

        //print("Performing backoff for \(backoffTime) time units.")
        self.senderInfo.0 = "Performing backoff for \(backoffTime) time units."
        print(currentAttempt)
        print(backoffTime)
        return Double(backoffTime)
    }

    func senseChannel(_ channel: TransmissionChannel) {
        //print("[Sender #\(self.id)]")
        //print("Sensing channel...")
        self.senderInfo.0 = "Sensing channel..."
        self.control += 1
        if channel.status == .occupied {
            self.senderInfo.0 = "Channel Occupied!"
            //print("Channel Occupied!")
            self.status = .backoff
            self.control = 0
        } else {
            if self.control == self.sensingTime {
                self.senderInfo.0 = "Can send Data!"
                //print("Can send Data!\n")
                //self.delegate?.startedToSendData(self.id)
                self.status = .canSendData
                self.control = 0
            } else {
                self.senderInfo.0 = "Channel free!"
                //print("Channel free!\n")
            }
        }
    }

    func sendData() {
        //print("[Sender #\(self.id)]")
        self.control += 1
        //print("Sending data...\n")
        self.senderInfo.0 = "Sending data..."
        self.delegate?.sendData(self.id, clock.now)
        if self.control == self.dataSize {
            self.senderInfo.0 = "Data sent!"
            //print("Data sent!\n")
            self.delegate?.dataSent(self.id, clock.now)
            self.status = .sensingChannel
            self.control = 0
            self.sensingTime += 3
        }
    }

    @objc func recivedCrash(notification: Notification) {
        self.status = .channelCrash
    }

    @objc func recivedCanSend(notification: Notification) {
        self.status = .sendingData
    }

}

enum SenderStatus {
    case sensingChannel
    case sendingData
    case canSendData
    case cantSendData
    case channelCrash
    case backoff
}

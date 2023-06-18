//
//  Simulation.swift
//  NetworksII
//
//  Created by Matheus Polonia on 15/06/23.
//

import SwiftUI
import Combine

final class Simulation: ObservableObject {
    
    @Published var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @Published var connectedTimer: Cancellable? = nil
    @Published var numberSquares: Int
    @Published var channel: TransmissionChannel
    @Published var connectedSenders: [Sender]
    @Published var status: SimulationStatus
    @Published var speed: Double

    init() {
        self.numberSquares = 5
        self.channel = TransmissionChannel()
        self.connectedSenders = []
        self.status = .paused
        self.speed = 1
    }

    func start() {
        self.instantiateTimer()
    }

    func run() {
        switch self.status {
        case .paused:
            return
        case .running:
            print("running")
            for index in 0..<self.connectedSenders.count {
                self.connectedSenders[index].run(self.channel)
            }
            self.channel.checkStatus()
        }
    }

    func tappedSender(_ position: (Int, Int)) {
        if let index = self.connectedSenders.firstIndex(where: {$0.position == position}) {
            self.connectedSenders.remove(at: index)
        } else {
            self.connectedSenders.append(Sender(id: self.connectedSenders.count + 1, position: position))
            self.channel.connectSender(self.connectedSenders.last!)
        }
    }

    func getSender(_ position: (Int, Int)) -> Sender? {
        if let sender = self.connectedSenders.first(where: {$0.position == position}) {
            print(sender.status)
            return sender
        }
        return nil
    }

    func instantiateTimer() {
        print("initiated")
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
        return
    }

    func restartTimer() {
        print("restarted")
        self.timer = Timer.publish(every: (1 * self.speed), on: .main, in: .common)
        self.instantiateTimer()
        return
    }

    func cancelTimer() {
        print("canceled")
        self.connectedTimer?.cancel()
        return
    }

    func changeSpeed(_ faster: Bool = true) {
        if faster {
            if Double(round(10 * self.speed) / 10) > Double(round(10 * 0.1) / 10) {
                self.speed -= 0.1
            }
        } else {
            if Double(round(10 * self.speed) / 10) < Double(round(10 * 2) / 10) {
                self.speed += 0.1
            }
        }
        self.cancelTimer()
        self.restartTimer()
    }
}

enum SimulationStatus {
    case running
    case paused
}

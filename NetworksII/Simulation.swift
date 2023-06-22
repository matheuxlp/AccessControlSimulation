//
//  Simulation.swift
//  NetworksII
//
//  Created by Matheus Polonia on 15/06/23.
//

import SwiftUI
import Combine

enum SimulationStatus {
    case running
    case paused
}

enum TotalDevices {
    public static let eight: Int = 3
    public static let sixteen: Int = 5
}

final class Simulation: ObservableObject {
    
    @Published var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @Published var connectedTimer: Cancellable? = nil
    @Published var totalDevices: Int
    @Published var channel: TransmissionChannel
    @Published var connectedDevices: [Device]
    @Published var status: SimulationStatus
    @Published var speed: Double

    @Published var infomationLog: [String] = []

    init() {
        self.totalDevices = TotalDevices.eight
        self.channel = TransmissionChannel()
        self.connectedDevices = []
        self.status = .paused
        self.speed = 2
    }
}

extension Simulation {
    func start() {
        self.instantiateTimer()
        self.channel.delegate = self
    }

    func restart() {
        self.status = .paused
        self.restartTimer()
        self.channel.restart()
        for device in self.connectedDevices {
            device.restart()
        }
    }

    func reset() {
        self.cancelTimer()
        self.speed = 1
        self.connectedDevices = []
        self.infomationLog = []
        self.status = .paused
        self.channel.reset()
        self.restartTimer()
    }

    func run() {
        switch self.status {
        case .paused:
            return
        case .running:
            for index in 0..<self.connectedDevices.count {
                self.connectedDevices[index].run(self.channel)
            }
            self.channel.checkStatus()
        }
    }
}

extension Simulation {
    func instantiateTimer() {
        self.connectedTimer = self.timer.connect()
    }

    func restartTimer() {
        self.timer = Timer.publish(every: (1 * self.speed), on: .main, in: .common)
        self.instantiateTimer()
    }

    func cancelTimer() {
        self.connectedTimer?.cancel()
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

extension Simulation: TransmissionChannelDelegate {
    func logInfo(log: String) {
        self.infomationLog.append(log)
    }
}

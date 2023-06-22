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
    @Published var totalDevices: Int
    @Published var channel: TransmissionChannel
    @Published var connectedDevices: [Device]
    @Published var status: SimulationStatus
    @Published var speed: Double

    init() {
        self.totalDevices = TotalDevices.eight
        self.channel = TransmissionChannel()
        self.connectedDevices = []
        self.status = .paused
        self.speed = 2
    }

    func start() {
        self.instantiateTimer()
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

    func tappedDevice(_ position: (Int, Int)) {
        if let index = self.connectedDevices.firstIndex(where: {$0.position == position}) {
            self.connectedDevices.remove(at: index)
        } else {
            self.connectedDevices.append(self.createDevice(position))
            self.channel.connectDevice(self.connectedDevices.last!)
        }
    }

    func getDevice(_ position: (Int, Int)) -> Device? {
        if let device = self.connectedDevices.first(where: {$0.position == position}) {
            return device
        }
        return nil
    }

    func instantiateTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
        return
    }

    func restartTimer() {
        self.timer = Timer.publish(every: (1 * self.speed), on: .main, in: .common)
        self.instantiateTimer()
        return
    }

    func cancelTimer() {
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

enum TotalDevices {
    public static let eight: Int = 3
    public static let sixteen: Int = 5
}

extension Simulation {
    
}

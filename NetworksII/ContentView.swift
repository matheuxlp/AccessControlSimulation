//
//  ContentView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 02/06/23.
//

import SwiftUI
import Combine

struct ContentView: View {

    @State var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State var timer2: Publishers.Autoconnect<Timer.TimerPublisher>

    @StateObject var channel: TransmissionChannel = TransmissionChannel()
    //@StateObject var sender1: Sender = Sender()
    //@StateObject var sender2: Sender = Sender(id: 2, sensingTime: 6)
    @State var senders: [Sender] = [Sender(), Sender(id: 2)]
    @State var loop: Int = 0

    init() {
        self.timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
        self.timer2 = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Loop \(self.loop)")
                HStack(alignment: .bottom) {
                    ForEach(self.senders) { sender in
                        SenderView(sender: sender, geometry: geometry)
                    }
                }
                Button {
                    self.addSender()
                } label: {
                    Text("Add another sender")
                }

            }
            .frame(width: geometry.frame(in: .global).width, height: geometry.frame(in: .global).height)
        }
        .onAppear {
            for sender in senders {
                self.channel.connectSender(sender)
            }
        }
        .onReceive(self.timer) { _ in
            for sender in senders {
                sender.run(self.channel)
            }
            self.channel.checkStatus()
            self.loop += 1
        }
    }

    private func addSender() {
        let sender = Sender(id: (senders.count + 1))
        self.senders.append(sender)
        self.channel.connectSender(sender)
    }
}

//                VStack {
//                    Rectangle()
//                        .fill(.white)
//                        .frame(width: 200, height: 200)
//                    Text("Channel")
//                    Text("Status: \(self.channel.status.rawValue)")
//                    Text("Number of sender sending: \(self.channel.recivingFrom.count)")
//                    if let info = self.channel.channelInfo {
//                        Text("\(info)")
//                    }
//                }

//
//  ContentView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 02/06/23.
//

import SwiftUI
import Combine

//struct ContentView: View {
//
//    @State var timer: Publishers.Autoconnect<Timer.TimerPublisher>
//    @State var timer2: Publishers.Autoconnect<Timer.TimerPublisher>
//
//    @StateObject var channel: TransmissionChannel = TransmissionChannel()
//    //@StateObject var sender1: Sender = Sender()
//    //@StateObject var sender2: Sender = Sender(id: 2, sensingTime: 6)
//    @State var senders: [Sender] = [Sender(), Sender(id: 2)]
//    @State var loop: Int = 0
//
//    @State var midPos: CGFloat = 0
//    @State var start: Bool = false
//
//    init() {
//        self.timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
//        self.timer2 = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                //ChannelView()
//                Text("a")
//            }
//            .padding(0)
//            .border(.red)
//            .frame(width: geometry.frame(in: .global).width, height: geometry.frame(in: .global).height)
//        }
//        .onAppear {
//            //for sender in senders {
//            //self.channel.connectSender(sender)
//            //}
//        }
//        .onReceive(self.timer) { _ in
//            //for sender in senders {
//            //sender.run(self.channel)
//            //}
//            //self.channel.checkStatus()
//            //self.loop += 1
//        }
//    }
//
//    private func addSender() {
//        let sender = Sender(id: (senders.count + 1))
//        self.senders.append(sender)
//        self.channel.connectSender(sender)
//    }
//}
//
//

//
//  SenderView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import SwiftUI

struct SendersView: View {

    @StateObject var sendersViewModel: SendersViewModel = SendersViewModel()
    @Binding var connectedSenders: [Sender]
    @Binding var channel: TransmissionChannel
    let numberSquares: Int
    let geometry: GeometryProxy

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<self.numberSquares, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<self.numberSquares, id: \.self) { column in
                        let position: (Int, Int) = (row, column)
                        Group {
                            if row == (self.numberSquares / 2) && column == (self.numberSquares / 2) {
                                ChannelView(size: geometry.size.height)
                            } else {
                                self.buildSender(position)
                            }
                        }
                        .frame(size: self.sendersViewModel.getSize(geometry.size.height, numberSquares: self.numberSquares))
                    }
                }
            }
        }
    }

    private func isEdge(_ row: Int, _ column: Int) -> Bool {
        return row == 0 || column == 0 || row == (self.numberSquares - 1) || column == (self.numberSquares - 1)
    }

    @ViewBuilder private func buildSender(_ position: (Int, Int)) -> some View {
        if self.isEdge(position.0, position.1) {
            if self.sendersViewModel.hasSender(self.connectedSenders, position) {
                SenderView(sender: self.connectedSenders.first(where: {$0.position == position})!)
                    .onTapGesture {
                        self.sendersViewModel.removeSender(self.$connectedSenders, self.$channel, position)
                    }
            } else {
                Text("NaN")
                    .onTapGesture {
                        self.sendersViewModel.addSender(self.$connectedSenders, self.$channel, position)
                    }
            }
        } else {
            Rectangle().fill(.clear)
        }
    }
}

final class SendersViewModel: ObservableObject {

    func getSize(_ height: CGFloat, numberSquares: Int) -> CGFloat {
        return height / CGFloat(numberSquares)
    }

    func hasSender(_ array: [Sender], _ position: (Int, Int)) -> Bool {
        return array.contains(where: {$0.position == position})
    }

    func createSender(_ connectedSenders: [Sender], _ position: (Int, Int)) -> Sender {
        var sensingTime = Double(Int.random(in: 3...10))
        if !connectedSenders.isEmpty {
            for sender in connectedSenders {
                if (sender.sensingTime - 1) <= sensingTime {
                    sensingTime += 2
                }
            }
        }
        let dataSize = Double(Int.random(in: 1...20))
        return Sender(id: (connectedSenders.count + 1), position: position, sensingTime: sensingTime, dataSize: dataSize, maxAttempts: 5)
    }

    func addSender(_ connectedSenders: Binding<[Sender]>, _ channel: Binding<TransmissionChannel>, _ position: (Int, Int)) {
        connectedSenders.wrappedValue.append(self.createSender(connectedSenders.wrappedValue, position))
        channel.wrappedValue.connectSender(connectedSenders.wrappedValue.last!)
    }

    func removeSender(_ connectedSenders: Binding<[Sender]>, _ channel: Binding<TransmissionChannel>, _ position: (Int, Int)) {
        if let index = connectedSenders.wrappedValue.firstIndex(where: {$0.position == position}) {
            connectedSenders.wrappedValue.remove(at: index)
        }
        if !connectedSenders.isEmpty {
            for index in 0..<connectedSenders.count {
                connectedSenders[index].wrappedValue.setId(index + 1)
            }
        }
    }

}


struct SenderView: View {
    @ObservedObject var sender: Sender

    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "display")
                    .font(.system(size: 32))
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.black)
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.red)
                    .offset(y: 10)
            }
            Text("#\(self.sender.id)")
                .foregroundColor(.black)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(Circle())
        .overlay(Circle().stroke(self.sender.color, lineWidth: 2))
    }

}

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
                                if self.sendersViewModel.hasSender(self.connectedSenders, position) {
                                    SenderView(sender: self.connectedSenders.first(where: {$0.position == position})!)
                                        .onTapGesture {
                                            if let index = self.connectedSenders.firstIndex(where: {$0.position == position}) {
                                                self.connectedSenders.remove(at: index)
                                            }
                                        }
                                } else {
                                    Text("NaN")
                                        .onTapGesture {
                                            self.connectedSenders.append(Sender(id: self.connectedSenders.count + 1, position: position))
                                            self.channel.connectSender(self.connectedSenders.last!)
                                        }
                                }
                            }
                        }
                        .frame(size: self.sendersViewModel.getSize(geometry.size.height, numberSquares: self.numberSquares))
                    }
                }
            }
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

}


struct SenderView: View {
    @ObservedObject var sender: Sender

    var body: some View {
        VStack {
            Image(systemName: "display")
                .font(.system(size: 32))
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.black)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
            Text("Status: \(self.sender.status.rawValue)")
        }
    }

}

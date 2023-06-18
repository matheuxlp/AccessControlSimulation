//
//  SenderView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import SwiftUI

struct SendersView: View {

    @EnvironmentObject var simulation: Simulation
    let geometry: GeometryProxy

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<self.simulation.numberSquares, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<self.simulation.numberSquares, id: \.self) { column in
                        Group {
//                            if row == 0 || row == simulation.numberSquares - 1 || column == 0 || column == simulation.numberSquares - 1 {
//
//                            } else if row == (self.simulation.numberSquares / 2) && column == (self.simulation.numberSquares / 2) {
//                                ChannelView(size: geometry.size.height)
//                            } else {
//                                Rectangle()
//                                    .fill(.clear)
//                            }
                            SenderView(position: (row, column))
                                .onTapGesture {
                                    self.simulation.tappedSender((row, column))
                                }
                        }
                        .frame(size: geometry.size.height / CGFloat(self.simulation.numberSquares))
                    }
                }
            }
        }
    }
}


struct SenderView: View {
    @EnvironmentObject var simulation: Simulation
    let position: (Int, Int)

    var body: some View {
        VStack {
            Image(systemName: "display")
                .font(.system(size: 32))
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.black)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
            //Text("Status: \(sender.status.rawValue)")
        }
    }

}

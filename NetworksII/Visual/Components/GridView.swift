//
//  GridView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 18/06/23.
//

import SwiftUI

//struct GridView: View {
//
//    let frameSize: CGFloat
//    @Binding var squareSize: Int
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ForEach(0..<self.simulation.numberSquares, id: \.self) { row in
//                HStack(spacing: 0) {
//                    ForEach(0..<self.simulation.numberSquares, id: \.self) { column in
//                        Group {
//                            if if row == (self.squareSize / 2) && column == (self.squareSize / 2) {
//                                ChannelView(size: geometry.size.height)
//                            } else {
//                                SenderView(position: (row, column))
//                                    .onTapGesture {
//                                        self.simulation.tappedSender((row, column))
//                                    }
//                            }
//                        }
//                        .frame(size: frameSize / CGFloat(self.simulation.numberSquares))
//                    }
//                }
//            }
//        }
//    }
//
//    //private func isValidRectangle()
//}

enum GridSize {
    public static let threeByThree: Int = 3
    public static let fiveByFive: Int = 5
}

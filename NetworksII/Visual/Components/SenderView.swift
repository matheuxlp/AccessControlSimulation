//
//  SenderView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import SwiftUI

struct SenderView: View {

    @StateObject var sender: Sender
    let geometry: GeometryProxy
    let rectSize: CGFloat

    init(sender: Sender, geometry: GeometryProxy) {
        self._sender = StateObject(wrappedValue: sender)
        self.geometry = geometry
        if self.geometry.frame(in: .global).height > self.geometry.frame(in: .global).width {
            self.rectSize = geometry.frame(in: .global).width / 6
        } else {
            self.rectSize = geometry.frame(in: .global).height / 6
        }
    }

    var body: some View {
        VStack {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .resizable()
                .scaledToFit()
                .frame(width: rectSize, height: rectSize)
                .padding(8)
            Text("Sender #\(self.sender.id)")
            if let info = self.sender.senderInfo.0 {
                Text("\(info)")
            }
        }
        .border(.blue)
    }
}

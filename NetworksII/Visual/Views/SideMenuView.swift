//
//  SideMenuView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 12/06/23.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        ZStack {
            VisualEffectView(material: NSVisualEffectView.Material.contentBackground, blendingMode: NSVisualEffectView.BlendingMode.withinWindow)
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

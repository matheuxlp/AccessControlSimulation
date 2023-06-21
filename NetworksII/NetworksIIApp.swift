//
//  NetworksIIApp.swift
//  NetworksII
//
//  Created by Matheus Polonia on 02/06/23.
//

import SwiftUI

@main
struct NetworksIIApp: App {
    @State private var window: NSWindow?
    var body: some Scene {
        WindowGroup {
            Main()
                .preferredColorScheme(.dark)
                .frame(minWidth: 1280, idealWidth: 1280, maxWidth: .infinity,
                       minHeight: 720, idealHeight: 720, maxHeight: .infinity)
                .background(WindowAccessor(window: $window))
                .onChange(of: window) { newWindow in
                    newWindow?.contentAspectRatio = CGSize(width: 16, height: 9)
                }

        }
        .commands {
            SidebarCommands() // 1
        }
        .windowResizability(.contentSize)

    }
}
struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window 
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

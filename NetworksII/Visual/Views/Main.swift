//
//  Main.swift
//  NetworksII
//
//  Created by Matheus Polonia on 12/06/23.
//

import SwiftUI

struct Main: View {

    @StateObject var simulation: Simulation = Simulation()
    @State var showMenu: Bool = false

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Group {
                    ZStack {
                        InformationView()
                            .zIndex(0)
                        if self.showMenu {
                            SideMenuView()
                                .zIndex(1)
                                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                        }
                    }
                    .frame(width: geometry.frame(in: .global).width / 3)
                    SimulationView()
                        .coordinateSpace(name: "simulation")
                }
                .environmentObject(self.simulation)
            }
            .frame(width: geometry.frame(in: .global).width, height: geometry.frame(in: .global).height)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        withAnimation {
                            self.showMenu.toggle()
                        }
                    }, label: {
                        Image(systemName: "sidebar.leading")
                    })
                }
                ToolbarItem(placement: .principal) {
                    Button {
                        withAnimation {
                            switch self.simulation.status {
                            case .running:
                                self.simulation.status = .paused
                            case .paused:
                                self.simulation.status = .running
                            }
                        }
                    } label: {
                        switch self.simulation.status {
                        case .running:
                            Image(systemName: "pause.fill")
                        case .paused:
                            Image(systemName: "play.fill")
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        withAnimation {
                            self.simulation.reset()
                        }
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                    })
                }
            }
        }
        .onAppear {
            self.simulation.start()
        }
        .onReceive(self.simulation.timer) { _ in
            self.simulation.run()
        }
    }
}

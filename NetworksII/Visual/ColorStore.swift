//
//  ColorStore.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import SwiftUI

class ColorStore: ObservableObject {
    @Published var color: Color

    init(color: Color) {
        self.color = color
    }
}

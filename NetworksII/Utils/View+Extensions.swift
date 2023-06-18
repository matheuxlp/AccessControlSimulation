//
//  View+Extensions.swift
//  NetworksII
//
//  Created by Matheus Polonia on 14/06/23.
//

import SwiftUI

extension View {
    func frame(size: CGFloat) -> some View {
        return self.frame(width: size, height: size)
    }
}

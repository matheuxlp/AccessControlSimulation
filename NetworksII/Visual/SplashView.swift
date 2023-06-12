//
//  SplashView.swift
//  NetworksII
//
//  Created by Matheus Polonia on 09/06/23.
//

import SwiftUI

struct SplashView: View {

    var animationType: SplashShape.SplashAnimation
    @State private var prevColor: Color // Stores background color
    @State var layers: [(Color,CGFloat)] = [] // New Color & Progress
    @ObservedObject var colorStore: ColorStore // Send new color updates


    init(animationType: SplashShape.SplashAnimation, color: Color) {
        self.animationType = animationType
        self._prevColor = State<Color>(initialValue: color)
        self.colorStore = ColorStore(color: color)
    }

    var body: some View {
        Rectangle()
            .foregroundColor(self.prevColor)
            .overlay(
                ZStack {
                    ForEach(layers.indices, id: \.self) { x in
                        SplashShape(progress: self.layers[x].1, animationType: self.animationType)
                            .foregroundColor(self.layers[x].0)
                    }

                }

                , alignment: .leading)
            .onReceive(self.colorStore.$color) { color in
                self.layers.append((color, 0))

                withAnimation(.easeInOut(duration: 0.5)) {
                    self.layers[self.layers.count-1].1 = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.prevColor = self.layers[0].0 // Finalizes background color of SplashView
                        self.layers.remove(at: 0) // removes itself from layers array
                    }
                }
            }
    }

}


//var colors: [Color] = [.blue, .red, .green, .orange]
//@State var index: Int = 0
//
//@State var progress: CGFloat = 0
//var body: some View {
//    VStack {
//        SplashView(animationType: .bottomToTop, color: self.colors[self.index])
//            .frame(width: 200, height: 100, alignment: .center)
//            .cornerRadius(10)
//
//        Button(action: {
//            self.index = (self.index + 1) % self.colors.count
//        }) {
//            Text("Change Color")
//        }
//        .padding(.top, 20)
//    }
//
//}
//}

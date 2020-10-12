//
//  FloatieLoader.swift
//  floatnote
//
//  Created by Michaela Barcia on 7/23/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

struct FloatieLoader: View {
    
    @State private var isAnimating = false
    @State private var showProgress = false
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        var image: some View {
            return Image("buoy")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundColor(Color.red)
        }
        return Button(action: { self.showProgress.toggle() }, label: {
            if showProgress {
                image
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                    .animation(self.isAnimating ? foreverAnimation : .default)
                    .onAppear { self.isAnimating = true }
                    .onDisappear { self.isAnimating = false }
            } else {
                image
            }
        })
        .onAppear { self.showProgress = true }
    }
}

struct FloatieLoader_Previews: PreviewProvider {
    static var previews: some View {
        FloatieLoader()
    }
}

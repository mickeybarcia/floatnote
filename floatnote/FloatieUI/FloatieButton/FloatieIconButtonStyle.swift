//
//  FloatieIconButtonStyle.swift
//  floatnote
//
//  Created by Michaela Barcia on 7/26/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

struct FloatieIconButtonStyle: ViewModifier {
    
    /// Whether the button is disabled
    var isEnabled: Bool = true

    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.floatieBlue)
            .font(.title)
            .scaleEffect(0.9)
            //.padding()
    }
    
}

//struct FloatieIconButtonStyle_Previews: PreviewProvider {
//    static var previews: some View {
//        FloatieIconButtonStyle()
//    }
//}

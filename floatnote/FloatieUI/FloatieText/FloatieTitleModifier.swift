//
//  FloatieTitleModifier.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/21/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Large sized title
struct FloatieTitle: View {
    
    /// The text
    var text: String
    
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).modifier(FloatieTitleModifier())
    }
    
}

struct FloatieTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.custom(FloatieFont.floatieBoldFont, size: 50))
    }
}

struct FloatieTitle_Previews: PreviewProvider {
    static var previews: some View {
        FloatieTitle("FLOAT NOTE").background(Color.floatieBlue)
    }
}

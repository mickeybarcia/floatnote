//
//  FloatieSubTitle.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/25/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Medium sized title
struct FloatieSubTitle: View {
    
    /// The text
    var text: String
    
    /// The color
    var color: Color
    
    init(_ text: String, color: Color = Color.white) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text.uppercased()).modifier(FloatieSubTitleModifier(color: color))
    }
    
}

/// Format the sub title
struct FloatieSubTitleModifier: ViewModifier {
    
    /// The color
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(.custom(FloatieFont.floatieBoldFont, size: 30))
    }
    
}

struct FloatieSubTitle_Previews: PreviewProvider {
    static var previews: some View {
        FloatieSubTitle("hello")
    }
}

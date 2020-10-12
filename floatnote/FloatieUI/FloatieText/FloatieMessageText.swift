//
//  FloatieMessageText.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/4/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Floatie info text
struct FloatieMessageText: View {
    
    /// The text
    var text: String
    
    // The font size
    var size: Int
    
    init(_ text: String, size: Int=20) {
        self.text = text
        self.size = size
    }

    var body: some View {
        Text(text).modifier(FloatieMessageTextModifier(size: self.size))
    }
    
}

/// Format the text
struct FloatieMessageTextModifier: ViewModifier {
    
    // The font size
    var size: Int
    
    func body(content: Content) -> some View {
        content
            .font(.custom(FloatieFont.floatieBoldFont, size: CGFloat(size)))
            .foregroundColor(Color.floatieBlue)
    }
}

struct FloatieMessageText_Previews: PreviewProvider {
    static var previews: some View {
        FloatieMessageText("hello")
    }
}

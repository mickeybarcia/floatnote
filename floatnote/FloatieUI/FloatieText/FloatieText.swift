//
//  FloatieText.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/21/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Basic Floatie text
struct FloatieText: View {
    
    /// The text
    var text: String
    
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).modifier(FloatieTextModifier())
    }
    
}

/// Format the text
struct FloatieTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom(FloatieFont.floatieFont, size: 18))
    }
}

struct FloatieText_Previews: PreviewProvider {
    static var previews: some View {
        FloatieText("hello")
    }
}

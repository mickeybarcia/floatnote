//
//  FloatieErrorText.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/23/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Wrapper for error message text
struct FloatieErrorText: View {
    
    /// The text
    var text: String
    
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).modifier(FloatieErrorTextModifier())
    }
    
}

/// Format the error message
struct FloatieErrorTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.red)
            .font(.custom(FloatieFont.floatieBoldFont, size: 18))
    }
}

/// Wrapper for error message text in form
struct FloatieFormErrorText: View {
    
    /// The text
    var text: String
    
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).modifier(FloatieFormErrorTextModifier())
    }
    
}

/// Format the error message
struct FloatieFormErrorTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.red)
            .font(.custom(FloatieFont.floatieBoldFont, size: 15))
            .padding(2)
    }
}

struct FloatieErrorText_Previews: PreviewProvider {
    static var previews: some View {
        FloatieErrorText("error")
    }
}

//
//  FloatieBarButton.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/17/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Small button of just text
struct FloatieBarButton: View {

    /// Changes display based on being disable
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    /// The button text
    var text: String
    
    /// The button action
    var action: () -> Void
    
    init(_ text: String, _ action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(action: self.action) {
            Text(self.text.uppercased()).modifier(FloatieBarButtonText(isEnabled: isEnabled))
        }
    }

}

/// The button styling
struct FloatieBarButtonText: ViewModifier {
    
    /// Whether the button is disabled
    var isEnabled: Bool

    func body(content: Content) -> some View {
        content
            .foregroundColor(isEnabled ? Color.floatieBlue : Color.floatieDisabled)
            .font(.custom(FloatieFont.floatieBoldFont, size: 19))
    }
    
}

struct FloatieBarButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatieBarButton("test", { print("test") })
    }
}

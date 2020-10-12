//
//  FloatieButton.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/2/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Large Floatie button
struct FloatieButton: View {
    
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
        Button(action: action) {
            Text(text.uppercased()).modifier(FloatieButtonText())
        }.buttonStyle(FloatieButtonStyle(isEnabled: isEnabled))
    }

}

/// The button styling
struct FloatieButtonStyle: ButtonStyle {
    
    /// Whether the button is disabled
    var isEnabled: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(isEnabled ? Color.floatieBlue : Color.floatieDisabled)
            .cornerRadius(40)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
    
}


/// The text of the button style
struct FloatieButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.custom(FloatieFont.floatieBoldFont, size: 30))
    }
}

struct FloatieButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatieButton("test", { print("test") })
    }
}

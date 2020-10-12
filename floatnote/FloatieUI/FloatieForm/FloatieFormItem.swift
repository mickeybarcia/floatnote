//
//  FloatieFormItem.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/20/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Wrapper for view in a form section
struct FloatieFormItem<Content: View>: View {
    
    /// View builder for adding items to a form section
    let content: () -> Content
    
    /// The label in the form
    var label: String
    
    init(label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }
    
    var body: some View {
        Section(header: Text(label.uppercased()).modifier(FloatieFormLabelModifier())) {
            content()
        }
    }
    
}

/// Format the label
struct FloatieFormLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.custom(FloatieFont.floatieBoldFont, size: 22))
    }
}

struct FloatieFormItem_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            FloatieFormItem(label: "test label") {
                Text("1")
                Text("2")
                Text("3")
            }
        }
    }
}

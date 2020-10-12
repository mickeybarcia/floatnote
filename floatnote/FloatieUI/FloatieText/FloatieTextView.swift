//
//  FloatieTextView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/20/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import UIKit
import SwiftUI

/// The Floatie wrapper for a text view
struct FloatieTextView: UIViewRepresentable {
        
    /// The text binding
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.font = UIFont(name: FloatieFont.floatieFont, size: 20)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator: NSObject, UITextViewDelegate {

        var parent: FloatieTextView

        init(_ uiTextView: FloatieTextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
    }
    
}

// reference: https://stackoverflow.com/questions/56471973/how-do-i-create-a-multiline-textfield-in-swiftui

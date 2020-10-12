//
//  FloatieFormField.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/9/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Text field in a form
struct FloatieFormField: View {
    
    // The validator
    typealias Validator = (String) -> String?
    @ObservedObject var field: FieldValidator<String>
    
    /// The label in the form
    var label: String
    
    /// The placeholder text
    var placeholder: String
    
    /// whether to validate on appear
    var showValidationOnEmpty: Bool
    
    init(
        label: String,
        value: Binding<String>,
        placeholder: String,
        checker: Binding<FieldChecker> = Binding.constant(FieldChecker()),
        validator: @escaping Validator = { _ in return nil },
        showValidationOnEmpty: Bool = true
    ) {
        self.label = label
        self.placeholder = placeholder
        self.showValidationOnEmpty = showValidationOnEmpty
        self.field = FieldValidator(value, checker: checker, validator: validator)
    }
    
    var body: some View {
        FloatieValidFormField(
            label: label,
            field: field,
            showValidationOnEmpty: showValidationOnEmpty
        ) {
            FloatieTextField(placeholder: self.placeholder, value: self.$field.value)
                .accessable(identifier: self.label)
        }
    }
    
}

/// The textfield wrapper for the form
struct FloatieTextField: View {
    
    /// The placeholder text
    var placeholder: String
    
    /// The text value to bind
    @Binding var value: String

    var body: some View {
         TextField(placeholder, text: _value)
            .autocapitalization(.none)
            .modifier(FloatieTextModifier())
    }
    
}

struct FloatieFormField_Previews: PreviewProvider {
    
    @State private static var name = ""
    @State private static var nameValid = FieldChecker()
    
    static var previews: some View {
        Form {
            FloatieFormField(
                label: "test texts",
                value: $name,
                placeholder: "sad sad sad",
                checker: $nameValid
            ) { item in
                if item.count < 1 {
                    return "name empty"
                }
                return nil
            }
        }
    }
    
}

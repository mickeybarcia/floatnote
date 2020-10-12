//
//  FloatieSecureFormField.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/17/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Text field in a form for passwords
struct FloatieSecureFormField: View {
    
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
        validator: @escaping Validator = { _ in return ""},
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
            FloatieSecureTextField(placeholder: self.placeholder, value: self.$field.value)
                .accessable(identifier: self.label)
        }
    }
    
}

/// The textfield wrapper for the form
struct FloatieSecureTextField: View {
    
    /// The placeholder text
    var placeholder: String
    
    /// The text value to bind
    @Binding var value: String

    var body: some View {
         SecureField(placeholder, text: _value)
            .autocapitalization(.none)
            .modifier(FloatieTextModifier())
    }
    
}

struct FloatieSecureFormField_Previews: PreviewProvider {
    @State private static var name = ""
    static var previews: some View {
        Form {
            FloatieSecureFormField(label: "test text", value: $name, placeholder: "test")
        }
    }
}

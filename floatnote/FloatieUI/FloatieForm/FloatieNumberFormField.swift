//
//  FloatieFormField.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/9/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI
import Combine

/// Text field in a form for numbers
struct FloatieNumberFormField: View {
    
    // The validator
    typealias Validator = (String) -> String?
    @ObservedObject var field: FieldValidator<String>
    
    /// The label in the form
    var label: String
    
    /// whether to validate on appear
    var showValidationOnEmpty: Bool
    
    init(
        label: String,
        value: Binding<String>,
        checker: Binding<FieldChecker> = Binding.constant(FieldChecker()),
        validator: @escaping Validator = { _ in return ""},
        showValidationOnEmpty: Bool = true
    ) {
        self.label = label
        self.showValidationOnEmpty = showValidationOnEmpty
        self.field = FieldValidator(value, checker: checker, validator: validator)
    }
    
    var body: some View {
        FloatieValidFormField(
            label: label,
            field: field,
            showValidationOnEmpty: showValidationOnEmpty
        ) {
            FloatieTextField(placeholder: "", value: self.$field.value)
            .accessable(identifier: self.label)
            .keyboardType(.numberPad)
            .onReceive(Just(self.field.value)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.field.value = filtered
                    }
            }
        }
    }
    
}

struct FloatieNumberFormField_Previews: PreviewProvider {
    @State private static var amount = "10"
    static var previews: some View {
        Form {
            FloatieNumberFormField(label: "test texts", value: $amount)
        }
    }
}

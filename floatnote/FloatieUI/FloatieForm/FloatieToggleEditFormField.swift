//
//  FloatieToggleEditFormField.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/29/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

struct FloatieToggleEditFormField: View {
    
    // The validator
    typealias Validator = (String) -> String?
    @ObservedObject var field: FieldValidator<String>
        
    /// The label in the form
    var label: String
    
    /// Switch between textfield and text
    @State var isEditable: Bool = false
    
    /// What happens when the change is saved
    var saveAction: () -> Void
    
    /// whether to validate on appear
    var showValidationOnEmpty: Bool
    
    @State var original: String
    
    init(
        label: String,
        value: Binding<String>,
        saveAction: @escaping () -> Void,
        checker: Binding<FieldChecker> = Binding.constant(FieldChecker()),
        validator: @escaping Validator = { _ in return nil },
        showValidationOnEmpty: Bool = true
    ) {
        self.label = label
        self.showValidationOnEmpty = showValidationOnEmpty
        self.field = FieldValidator(value, checker: checker, validator: validator)
        self.saveAction = saveAction
        _original = /*State<String>*/.init(initialValue: value.wrappedValue)
    }
    
    var body: some View {
        FloatieFormItem(label: label) {
            if self.isEditable {
                HStack {
                    FloatieBarButton("cancel", {
                        self.isEditable = false
                        self.field.setValue(value: self.original)
                    })
                    Spacer()
                    FloatieBarButton(
                        "save",
                        {
                            self.isEditable = false
                            self.saveAction()
                            self.original = self.$field.value.wrappedValue
                        }
                    ).disabled(!self.field.isValid)
                }.buttonStyle(BorderlessButtonStyle())
                VStack {
                    FloatieTextField(placeholder: self.original, value: self.$field.value)
                        .accessable(identifier: self.label)
                    FloatieFormFieldValidationIndicator(
                        field: self.field,
                        showValidationOnEmpty: self.showValidationOnEmpty
                    )
                }.onAppear { self.field.doValidate() }
            } else {
                HStack {
                    FloatieText(self.original)
                    Spacer()
                    FloatieBarButton("edit", { self.isEditable = true })
                }
            }
        }
    }
    
}

struct FloatieToggleEditFormField_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            FloatieToggleEditFormField(label: "test", value: .constant("test"), saveAction: {})
        }
    }
}

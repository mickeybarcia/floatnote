//
//  FloatieFieldValidator.swift
//  floatnote
//
//  Created by Michaela Barcia on 7/20/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation
import SwiftUI

struct FloatieValidFormField<Content: View>: View {
    
    // The validator
    typealias Validator = (String) -> String?
    @ObservedObject var field: FieldValidator<String>
    
    /// View builder for adding items to a form section
    let content: () -> Content
    
    /// The label in the form
    var label: String
    
    /// whether to validate on appear
    var showValidationOnEmpty: Bool
    
    init(
        label: String,
        field: FieldValidator<String>,
        showValidationOnEmpty: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.label = label
        self.showValidationOnEmpty = showValidationOnEmpty
        self.field = field
    }
    
    var body: some View {
        FloatieFormItem(label: label) {
            VStack {
                self.content()
                FloatieFormFieldValidationIndicator(
                    field: self.field,
                    showValidationOnEmpty: self.showValidationOnEmpty
                )
            }
        }.onAppear { self.field.doValidate() }
    }
    
}

struct FloatieFormFieldValidationIndicator: View {
    
    @ObservedObject var field: FieldValidator<String>
    
    /// whether to validate on appear
    var showValidationOnEmpty: Bool = true
    
    var validationException: Bool {
        !self.showValidationOnEmpty && self.field.value.count == 0
    }
        
    var body: some View {
        return VStack {
            if !self.field.isValid && !self.validationException {
                Divider()
                    .frame(height: 1)
                    .background(Color.red)
                HStack {
                    FloatieFormErrorText(self.field.errorMessage ?? "")
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            } else {
                Divider()
                    .frame(height: 1)
                    .background(Color.floatieDarkBlue)
            }
        }
    }
}


struct FieldChecker {
    var errorMessage: String? = nil
    var valid: Bool { self.errorMessage == nil }
}

class FieldValidator<T> : ObservableObject where T : Hashable {

    typealias Validator = (T) -> String?

    @Binding private var bindValue: T
    @Binding private var checker: FieldChecker

    @Published var value: T {
        willSet { self.doValidate(newValue) }
        didSet { self.bindValue = self.value }
    }
    private let validator: Validator

    var isValid: Bool { self.checker.valid }
    var errorMessage: String? { self.checker.errorMessage }

    init(_ value: Binding<T>, checker: Binding<FieldChecker>, validator: @escaping Validator) {
        self.validator  = validator
        self._bindValue = value
        self.value      = value.wrappedValue
        self._checker   = checker
    }

    func doValidate( _ newValue: T? = nil ) -> Void {
        self.checker.errorMessage = (newValue != nil) ?
             self.validator(newValue!) :
             self.validator(self.value)
    }
    
    func setValue(value: T) {
        self.value = value
    }

}

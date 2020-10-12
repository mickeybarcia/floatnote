//
//  FloatieDatePickerFormField.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/5/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Date picker form field
struct FloatieDatePickerFormField: View {
    
    /// The form label
    var label: String
    
    /// Date binding
    @Binding var date: Date
    
    var body: some View {
        FloatieFormItem(label: self.label) {
            DatePicker(
                selection: self.$date,
                in: ...Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                displayedComponents: .date
            ) {
                FloatieText("day")
            }
            DatePicker(selection: self.$date, displayedComponents: .hourAndMinute) {
                FloatieText("time")
            }
        }
    }
}

struct FloatieDatePickerFormField_Previews: PreviewProvider {
    static var previews: some View {
        FloatieDatePickerFormField(label: "test", date: .constant(Date()))
    }
}

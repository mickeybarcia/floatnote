//
//  JournalFilterView.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/7/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Allows filters to be applied to the entries displayed
struct JournalFilterView: View {
    
    @EnvironmentObject private var journal: JournalState
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var infoMessage = ""
    @State private var errorMessage = "end date must be after start date.."
    
    @State private var startDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
    @State private var endDate = Date()
    
    /// Start date must come before
    var dateInvalid: Bool {
        startDate > endDate
    }
    
    var body: some View {
        VStack {
            if dateInvalid {
                FloatieBanner($errorMessage)
            } else {
                FloatieBanner($journal.errorMessage, infoMessage: $journal.infoMessage)
            }
            Form {
                FloatieDatePickerFormField(label: "beginning date", date: $startDate)
                FloatieDatePickerFormField(label: "end date", date: $endDate)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: FloatieBarButton("cancel", dismiss),
            trailing: FloatieBarButton("save", filterEntries)
                        .disabled(dateInvalid || self.journal.isLoading)
        )
    }
    
    /// Applies the filters to the journal and closes the view
    private func filterEntries() {
        journal.getEntries(
            startDate: startDate,
            endDate: endDate,
            onSuccess: {
                self.dismiss()
            }
        )
    }
    
    private func dismiss() {
         self.presentationMode.wrappedValue.dismiss()
     }
    
}

struct JournalFilterView_Previews: PreviewProvider {
    static var previews: some View {
        JournalFilterView().environmentObject(JournalState())
    }
}

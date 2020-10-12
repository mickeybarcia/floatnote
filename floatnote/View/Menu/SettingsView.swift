//
//  SettingsView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/28/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Form {
            FloatieFormItem(label: "preferences") {
                FloatieText("to do...")
            }
            FloatieFormItem(label: "notifications") {
                FloatieText("to do...")
            }
            FloatieFormItem(label: "privacy") {
                FloatieText("to do...")
            }
            FloatieFormItem(label: "terms and conditions") {
                FloatieText("to do...")
            }
            FloatieFormItem(label: "version") {
                FloatieText("beta")
            }
        }
        .navigationBarTitle("SETTINGS")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: FloatieBarButton(
                "back",
                { self.presentationMode.wrappedValue.dismiss() }
            )
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

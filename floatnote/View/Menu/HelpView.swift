//
//  HelpView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/28/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    
    @EnvironmentObject private var auth: AuthState
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.floatieDarkBlue.edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                if auth.isNewUser {
                    FloatieSubTitle("welcome to float note new frand")
                }
                FloatieText("type up your journal entry")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    // screen shot of plus sign and entry view
                FloatieText("or take pictures up your handwritten entry")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    // switch form and add image views
                FloatieText("view your digital journal")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    // journal and filter view
                FloatieText("view your stats in the dashboard")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    // dashboard views
                FloatieButton("got it", dismiss)
            }
        }
    }
    
    private func dismiss() {
        if auth.isNewUser {
            auth.welcomedNewUser()
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView().environmentObject(AuthState())
    }
}

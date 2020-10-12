//
//  VerifyEmailView.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/5/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// View to send a verification email
struct VerifyEmailView: View {

    @EnvironmentObject private var auth: AuthState
    @State private var disableButton = false
    @State private var infoMessage = ""
    @State private var errorMessage = ""
    private let RESEND_INFO_MSG = "please check your email to verify your account or update your email in the account section of the main menu.."
    
    init() {
        _infoMessage = /*State<String>*/.init(initialValue: self.RESEND_INFO_MSG)
    }
    
    var body: some View {
        ZStack {
            Color.floatieDarkBlue.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                FloatieLogo.BIG_LOGO
                FloatieBanner($errorMessage, infoMessage: $infoMessage)
                FloatieBarButton("resend email", self.resendVerification)
                    .disabled(self.disableButton)
                FloatieBarButton("refresh", self.refresh)
                    .disabled(self.disableButton)
            }
        }
    }
    
    /// Resends the email
    private func resendVerification() {
        self.disableButton = true
        auth.resendVerification(
            onSuccess: { successMessage in
                self.infoMessage = successMessage
                self.errorMessage = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.disableButton = false
                }
            },
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.infoMessage = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.disableButton = false
                }
            }
        )
    }
    
    /// Resends the email
    private func refresh() {
        self.disableButton = true
        self.auth.getCurrentUser()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.disableButton = false
        }
    }

}

struct VerifyEmailView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyEmailView().environmentObject(AuthState())
    }
}

//
//  LoginView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/1/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The login view
struct LoginView: View {
    
    @EnvironmentObject private var auth: AuthState
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var usernameOrEmail: String = ""
    @State private var usernameChecker = FieldChecker()
    @State private var password: String = ""
    @State private var passwordChecker = FieldChecker()
    
    @State private var showChangePassword = false
    @State private var showForgotPassword = false
    @State private var isLoading = false
    
    @State private var infoMessage: String = ""
    @State private var errorMessage: String = ""
        
    /// Check for min characters in login info
    private var disableLogin: Bool {
        return !usernameChecker.valid || !passwordChecker.valid
    }

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                FloatieBanner($errorMessage, infoMessage: $infoMessage)
                Form {
                    FloatieFormField(
                        label: "username or email",
                        value: $usernameOrEmail,
                        placeholder: "mickey",
                        checker: $usernameChecker,
                        showValidationOnEmpty: false
                    ) { username in
                        if username.count < 5 {  // TODO - distinguish username from email
                            return FormUtil.INVALID_LOGIN_USERNAME_ERR
                        }
                        return nil
                    }
                    if !showForgotPassword {
                        FloatieSecureFormField(
                            label: "password",
                            value: $password,
                            placeholder: "shhh",
                            checker: $passwordChecker,
                            showValidationOnEmpty: false
                        ) { password in
                            return !FormUtil.isValidPassword(password) ? FormUtil.INVALID_LOGIN_PASSWORD_ERR : nil
                        }
                        FloatieButton("login", login)
                            .disabled(self.disableLogin || self.isLoading)
                        HStack {
                            Spacer()
                            FloatieBarButton("forgot password", self.openForgotPassword)
                            Spacer()
                        }
                    } else {
                        FloatieButton("send reset", resetPassword)
                            .disabled(!self.usernameChecker.valid || self.isLoading)
                        HStack {
                            Spacer()
                            FloatieBarButton("cancel", self.cancelForgotPassword)
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("LOGIN")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: FloatieBarButton("back", self.dismiss))
        .onDisappear {
            self.errorMessage = ""
            self.infoMessage = ""
        }
        .onAppear {
            if FloatieEnvironment.CONFIGURATION == "Debug" {
                self.auth.login(
                    usernameOrEmail: "mickey11",  // TODO move to config
                    password: "mickey1",
                    onSuccess: {},
                    onFailure: { errorMessage in
                        self.errorMessage = errorMessage
                    }
                )
            }
        }
    }
    
    /// Shows a button and message to reset password
    private func openForgotPassword() {
        self.errorMessage = ""
        self.infoMessage = ""
        self.showForgotPassword = true
    }
    
    /// Hides the button and message to reset password
    private func cancelForgotPassword() {
        self.infoMessage = ""
        self.showForgotPassword = false
    }
    
    /// Make request for rest password
    private func resetPassword() {
        isLoading = true
        auth.forgotPassword(
            usernameOrEmail: usernameOrEmail,
            onSuccess: { infoMessage in
                self.errorMessage = ""
                self.infoMessage = infoMessage
                self.isLoading = false
            },
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.infoMessage = ""
                self.isLoading = false
            }
        )
    }
    
    /// Login and show a change password view if you need to be prompted to do so
    private func login() {
        self.isLoading = true
        auth.login(
            usernameOrEmail: usernameOrEmail,
            password: password,
            onSuccess: { 
                self.isLoading = false
            },
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.infoMessage = ""
                self.isLoading = false
            }
        )
    }
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthState())
    }
}

//
//  FloatiePasswordChangeFormView.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/4/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// View to change password
struct PasswordChangeView: View {

    @EnvironmentObject private var auth: AuthState
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var confirmedNewPassword: String = ""
    @State private var confirmedNewPasswordChecker = FieldChecker()
    @State private var newPassword: String = ""
    @State private var newPasswordChecker = FieldChecker()
    @State private var oldPassword: String = ""
    @State private var oldPasswordChecker = FieldChecker()
    
    @State private var isLoading = false
    @State private var errorMessage: String = ""
    @State private var infoMessage: String = ""
    
    /// Looks to see passwords match, are unique, and proper
    private var passwordInvalid: Bool {
        return !confirmedNewPasswordChecker.valid
            || !newPasswordChecker.valid
            || !oldPasswordChecker.valid
    }

    var body: some View {
        VStack {
            FloatieBanner($errorMessage, infoMessage: $infoMessage)
            Form {
                FloatieSecureFormField(
                    label: "old password",
                    value: $oldPassword,
                    placeholder: "shh",
                    checker: $oldPasswordChecker,
                    showValidationOnEmpty: false
                ) { oldPassword in
                    if self.newPassword != oldPassword {
                        self.newPasswordChecker.errorMessage = nil
                    } else {
                        self.newPasswordChecker.errorMessage = FormUtil.PASSWORD_MUST_BE_NEW_ERR
                    }
                    return !FormUtil.isValidPassword(oldPassword) ? FormUtil.INVALID_PASSWORD_ERR : nil
                }
                FloatieSecureFormField(
                    label: "new password",
                    value: $newPassword,
                    placeholder: "shh",
                    checker: $newPasswordChecker,
                    showValidationOnEmpty: false
                ) { newPassword in
                    if !FormUtil.isValidPassword(newPassword) {
                        return FormUtil.INVALID_PASSWORD_ERR
                    }
                    if newPassword == self.oldPassword {
                        return FormUtil.PASSWORD_MUST_BE_NEW_ERR
                    }
                    return nil
                }
                FloatieSecureFormField(
                    label: "confirm new password",
                    value: $confirmedNewPassword,
                    placeholder: "shh",
                    checker: $confirmedNewPasswordChecker,
                    showValidationOnEmpty: false
                ) { confirmedPassword in
                    return self.newPassword != confirmedPassword ? FormUtil.INVALID_PASSWORDS_NOT_MATCH_ERR : nil
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: FloatieBarButton("back", dismiss),
            trailing: FloatieBarButton("save", savePassword)
                        .disabled(self.passwordInvalid || self.isLoading)
        )
        .onDisappear {
            self.errorMessage = ""
            self.infoMessage = ""
        }
    }
    
    /// Update password
    private func savePassword() {
        self.isLoading = true
        auth.updatePassword(
            oldPassword: self.oldPassword,
            newPassword: self.newPassword,
            onSuccess: {
                self.dismiss()
                self.infoMessage = "password update successful"
                self.isLoading = false
            },
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.newPassword = ""
                self.confirmedNewPassword = ""
                self.isLoading = false
            }
        )
    }
    
    private func dismiss() {
         self.presentationMode.wrappedValue.dismiss()
     }
    
}

struct PasswordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordChangeView().environmentObject(AuthState())
    }
}

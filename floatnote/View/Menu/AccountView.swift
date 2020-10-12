//
//  AccountView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/29/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// View and edit account
struct AccountView: View {
    
    private var prevUser: User

    @EnvironmentObject private var auth: AuthState
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var selection: Int? = nil
    
    @State private var username: String = ""
    @State private var usernameChecker = FieldChecker()
    @State private var email: String = ""
    @State private var emailChecker = FieldChecker()
    
    @State private var successMessage: String = ""
    @State private var errorMessage: String = ""
    
    @State private var usernameNotUnique: Bool = false
    @State private var showDeleteAlert = false

    init(user: User) {
        self.prevUser = user
        _email = /*State<String>*/.init(initialValue: user.email)
        _username = /*State<String>*/.init(initialValue: user.username)
    }
    
    var body: some View {
        VStack {
            FloatieBanner($errorMessage, infoMessage: $successMessage)
            Form {
                FloatieToggleEditFormField(
                    label: "username",
                    value: $username,
                    saveAction: saveUsername,
                    checker: $usernameChecker
                ) { username in
                    if !FormUtil.isValidUsername(username) {
                        return FormUtil.INVALID_USERNAME_ERR
                    } else {
                        self.auth.validateUsername(
                            username: username,
                            onSuccess: {},
                            onFailure: { error in
                                self.usernameChecker.errorMessage = error
                                self.usernameNotUnique = true
                            }
                        )
                        if (username == self.prevUser.username) {
                            return FormUtil.USERNAME_MUST_BE_DIFFERENT_ERR
                        }
                    }
                    return nil
                }
                FloatieToggleEditFormField(
                    label: "email",
                    value: $email,
                    saveAction: saveEmail,
                    checker: $emailChecker
                ) { email in
                    if !FormUtil.isValidEmail(email) {
                        return FormUtil.INVALID_EMAIL_ERR
                    } else if (email == self.prevUser.email) {
                        return FormUtil.EMAIL_MUST_BE_DIFFERENT_ERR
                    }
                    return nil
                }
                FloatieFormItem(label: "password") {
                    NavigationLink(
                        destination: PasswordChangeView().environmentObject(self.auth),
                        tag: 1,
                        selection: self.$selection
                    ) {
                        FloatieBarButton("edit password", { self.selection = 1 })
                    }
                }
                FloatieFormItem(label: "account") {
                    FloatieBarButton("delete account", { self.showDeleteAlert = true })
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account?"),
                primaryButton: .destructive(Text("Yes")) {
                    self.deleteAccount()
                },
                secondaryButton: .cancel() {
                    self.showDeleteAlert = false
                }
            )
        }
        .onDisappear {
            self.errorMessage = ""
            self.successMessage = ""
        }
        .navigationBarTitle("ACCOUNT")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: FloatieBarButton("back", dismiss))
    }
    
    /// Delete account after showing alert
    private func deleteAccount() {
        auth.deleteAccount(
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.successMessage = ""
            }
        )
    }
    
    /// Save new username and update current user
    private func saveUsername() {
        auth.updateUsername(
            username: username,
            onSuccess: { successMessage in
                self.prevUser.username = self.username
                self.successMessage = successMessage
                self.errorMessage = ""
            },
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.successMessage = ""
            }
        )
    }
    
    /// Save new email and update current user
    private func saveEmail() {
        auth.updateEmail(
            email: self.email,
            onSuccess: { successMessage in
                self.prevUser.email = self.email
                self.successMessage = successMessage
            },
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.successMessage = ""
            }
        )
    }
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(user: User.defaultUser()).environmentObject(AuthState())
    }
}

//
//  SignupView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/1/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The form to signup
struct SignupView: View {
    
    @EnvironmentObject private var auth: AuthState
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var username: String = ""
    @State private var usernameChecker = FieldChecker()
    @State private var usernameNotUnique: Bool = true
    @State private var email: String = ""
    @State private var emailChecker = FieldChecker()
    @State private var password: String = ""
    @State private var passwordChecker = FieldChecker()
    @State private var confirmPassword: String = ""
    @State private var confirmPasswordChecker = FieldChecker()
    @State private var age: String = ""
    @State private var ageChecker = FieldChecker()

    @State private var gender: String = ""
    @State private var mentalHealthStatus: String = ""
    
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    
    private var disableSignup: Bool {
        return usernameNotUnique
            || !usernameChecker.valid
            || !passwordChecker.valid
            || !emailChecker.valid
            || !confirmPasswordChecker.valid
            || !ageChecker.valid
    }
    
    var body: some View {
        VStack {
            FloatieBanner($errorMessage)
            Form {
                FloatieFormField(
                    label: "username *",
                    value: $username,
                    placeholder: "mickey",
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
                    }
                    return nil
                }
                FloatieFormField(
                    label: "email *",
                    value: $email,
                    placeholder: "mickey@email.com",
                    checker: $emailChecker,
                    showValidationOnEmpty: false
                ) { email in
                    return !FormUtil.isValidEmail(email) ? FormUtil.INVALID_EMAIL_ERR : nil
                }
                FloatieFormField(
                    label: "password *",
                    value: $password,
                    placeholder: "shhh",
                    checker: $passwordChecker
                ) { password in
                    return !FormUtil.isValidPassword(password) ? FormUtil.INVALID_PASSWORD_ERR : nil
                }
                FloatieSecureFormField(
                    label: "confirm password *",
                    value: $confirmPassword,
                    placeholder: "shhh",
                    checker: $confirmPasswordChecker,
                    showValidationOnEmpty: false
                ) { confirmPassword in
                    return confirmPassword == self.password ? FormUtil.INVALID_PASSWORDS_NOT_MATCH_ERR : nil
                }
                FloatieNumberFormField(
                    label: "age *",
                    value: $age,
                    checker: $ageChecker,
                    showValidationOnEmpty: false 
                ) { age in
                    if let intAge = Int(age), intAge > 0 && intAge < 120 {
                       return nil
                    }
                    return FormUtil.INVALID_AGE_ERR
                }
                FloatieFormField(
                    label: "gender",
                    value: $gender,
                    placeholder: ""
                )
                FloatieFormField(
                    label: "mental health status",
                    value: $mentalHealthStatus,
                    placeholder: "floating"
                )
                FloatieButton("signup", signup).disabled(disableSignup || isLoading)
            }
        }
        .onDisappear { self.errorMessage = "" }
        .navigationBarTitle("SIGNUP")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: FloatieBarButton("back", dismiss))
    }
    
    /// Signup request
    private func signup() {
        self.isLoading = true
        auth.signup(
            user: User(
                username: username,
                password: password,
                email: email,
                age: Int(age) ?? 0,
                gender: gender.trimmingCharacters(in: .whitespaces),
                mentalHealthStatus: mentalHealthStatus.trimmingCharacters(in: .whitespaces)
            ),
            onSuccess: {
                self.isLoading = false
            },
            onFailure: { errorMessage in
                self.errorMessage = errorMessage
                self.isLoading = false
            }
        )
    }
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

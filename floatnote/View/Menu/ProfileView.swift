//
//  ProfileView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/28/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// View and edit profile details
struct ProfileView: View {
    
    private var prevUser: User

    @EnvironmentObject private var auth: AuthState
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State private var gender: String = ""
    @State private var mentalHealthStatus: String = ""
    
    @State private var isLoading = false
    
    var isNewInfo: Bool {
        return prevUser.gender ?? "" != gender
            || prevUser.mentalHealthStatus ?? "" != mentalHealthStatus
    }
    
    @State private var errorMessage: String = ""
    @State private var successMessage: String = ""
        
    init(user: User) {
        self.prevUser = user
        _gender = /*State<String>*/.init(initialValue: user.gender ?? "")
        _mentalHealthStatus = /*State<String>*/.init(initialValue: user.mentalHealthStatus ?? "")
    }
    
    var body: some View {
        VStack {
            FloatieBanner($errorMessage, infoMessage: $successMessage)
            Form {
                FloatieFormField(
                    label: "gender",
                    value: self.$gender,
                    placeholder: ""
                )
                FloatieFormField(
                    label: "mental health status",
                    value: self.$mentalHealthStatus,
                    placeholder: "floating"
                )
            }
        }
        .onDisappear {
            self.successMessage = ""
            self.errorMessage = ""
        }
        .navigationBarTitle("PROFILE")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: FloatieBarButton("back", self.dismiss),
            trailing: FloatieBarButton("save", self.saveProfileDetails)
                        .disabled(!self.isNewInfo || self.isLoading)
        )
    }
    
    /// Save the changes
    private func saveProfileDetails() {
        self.isLoading = true
        auth.updateProfile(
            gender: gender.trimmingCharacters(in: .whitespaces),
            mentalHealthStatus: mentalHealthStatus.trimmingCharacters(in: .whitespaces),
            onSuccess: { successMessage in
                self.successMessage = successMessage
                self.errorMessage = ""
                self.prevUser.mentalHealthStatus = self.mentalHealthStatus
                self.prevUser.gender = self.gender
                self.isLoading = false
            },
            onFailure: { errorMessage in
                self.successMessage = ""
                self.errorMessage = errorMessage
                self.isLoading = false
            }
        )
    }
    
    private func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: User.defaultUser()).environmentObject(AuthState())
    }
}

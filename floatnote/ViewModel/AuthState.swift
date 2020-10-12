//
//  LoginViewModel.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/11/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Makes auth calls to service and stores auth details
final class AuthState: ObservableObject {
    
    /// Controls which default view is shown
    @Published private (set) var isLoggedIn = false
    
    /// Show the new user intro if true
    @Published private (set) var isNewUser = false
    
    /// The signed in user
    @Published private (set) var user: User?
    
    private var service: FloatieService
    
    init(floatieService: FloatieService=FloatieService()) {
        self.service = floatieService
    }
    
    /// Mark that the user saw the intro screen
    func welcomedNewUser() {
        isNewUser = false
    }
        
    /// Make login call to service
    /// - Parameters:
    ///   - username: username
    ///   - password: password
    ///   - onSuccess: notify view
    ///   - onFailure: pass error message to display
    func login(
        usernameOrEmail: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        service.login(
            usernameOrEmail: usernameOrEmail,
            password: password,
            onSuccess: {
                self.isLoggedIn = true
                self.getCurrentUser()
                onSuccess()
            },
            onFailure: { error in
                switch error {
                case .invalidCredentials:
                    onFailure("invalid username or password..")
                default:
                    onFailure("unable to login.. try again later")
                }
            }
        )
    }

    /// Sign in a new user
    /// - Parameters:
    ///   - user: the user object to create
    ///   - onFailure: get the error to display
    func signup(
        user: User,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        service.register(
            user: user,
            onSuccess: {
                self.isLoggedIn = true
                self.isNewUser = true
                self.getCurrentUser()
                onSuccess()
            },
            onFailure: { error in
                switch error {
                    case .usernameExists:
                        onFailure("username already exists..")
                    default:
                        onFailure("unable to register.. try again later")
                }
            }
        )
    }
    
    /// Get current signed in user
    func getCurrentUser() {
        service.getCurrentUser(
            onSuccess: { user in
                self.user = user
            },
            onFailure: {}
        )
    }
    
    /// Logout and nullify user
    func logout() {
        service.logout(
            onSuccess: {
                self.user = nil
                self.isLoggedIn = false
            }
        )
    }
    
    /// Update profile details
    /// - Parameters:
    ///   - gender: gender
    ///   - mentalHealthStatus: mentalHealthStatus
    ///   - onSuccess: return success message
    ///   - onFailure: return failure message
    func updateProfile(
        gender: String?,
        mentalHealthStatus: String?,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        var profileChanges: [String: String] = [:]
        if let gender = gender {
            profileChanges["gender"] = gender
        }
        if let mentalHealthStatus = mentalHealthStatus {
            profileChanges["mentalHealthStatus"] = mentalHealthStatus
        }
        service.updateProfile(
            profileChanges: profileChanges,
            onSuccess: { user in
                self.user = user
                onSuccess("successfully updated profile")
            },
            onFailure: {
                onFailure("unable to update profile.. try again later")
            }
        )
    }
    
    /// Update username
    /// - Parameters:
    ///   - username: username
    ///   - onSuccess: return success message and update user model
    ///   - onFailure: return failure message
    func updateUsername(
        username: String,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        service.updateUsername(
            username: username,
            onSuccess: {
                self.user?.username = username
                onSuccess("successfully updated username")
            },
            onFailure: { error in 
                switch error {
                    case .usernameExists:
                        onFailure("username already exists..")
                    default:
                        onFailure("unable to update username.. try again later")
                }
            }
        )
    }
    
    /// Update email and reset isVerfied
    /// - Parameters:
    ///   - email: email
    ///   - onSuccess: return success message and update user model
    ///   - onFailure: return failure message
    func updateEmail(
        email: String,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        service.updateEmail(
            email: email,
            onSuccess: {
                self.user?.email = email
                self.user?.isVerified = false
                onSuccess("check your email for a verification email")
            },
            onFailure: {
                onFailure("unable to update email.. try again later")
            }
        )
    }
    
    /// Check username is unique
    /// - Parameters:
    ///   - username: username
    ///   - onSuccess: mark success
    ///   - onFailure: send failure message if username exists, else don't show error
    func validateUsername(
        username: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        service.validateUsername(
            username: username,
            onSuccess: {
                onSuccess()
            },
            onFailure: { error in
                switch error {
                    case .usernameExists:
                        onFailure("username already exists..")
                    default:
                        return
                }
            }
        )
    }
    
    /// Delete account
    /// - Parameter onFailure: return failure message
    func deleteAccount(onFailure: @escaping (String) -> Void) {
        service.deleteUser(
            onSuccess: {
                // TODO anything else
                self.logout()
            },
            onFailure: {
                onFailure("unable to delete user.. try again later")
            }
        )
    }
    
    /// Resend verification email
    /// - Parameters:
    ///   - onSuccess: return success message
    ///   - onFailure: return failure message
    func resendVerification(
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        if let user = self.user {
            service.resendVerification(
                email: user.email,
                onSuccess: {
                    onSuccess("email sent")
                },
                onFailure: {
                    onFailure("unable to resend email.. try again later")
                }
            )
        }
    }
    
    /// Send forgot password request
    /// - Parameters:
    ///   - usernameOrEmail: usernameOrEmail
    ///   - onSuccess: return success message
    ///   - onFailure: return failure message
    func forgotPassword(
        usernameOrEmail: String,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        service.forgotPassword(
            usernameOrEmail: usernameOrEmail,
            onSuccess: {
                onSuccess("email sent")
            },
            onFailure: {
                onFailure("unable to send forgot password email.. try again later")
            }
        )
    }
    
    /// Update password
    /// - Parameters:
    ///   - usernameOrEmail: usernameOrEmail
    ///   - oldPassword: oldPassword
    ///   - newPassword: newPassword
    ///   - onSuccess: update password on user and login if not logged in
    ///   - onFailure: return failure message
    func updatePassword(
        oldPassword: String,
        newPassword: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
     ) {
         service.updatePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            onSuccess: {
                self.user?.password = newPassword
                if let user = self.user {
                    self.service.login(
                        usernameOrEmail: user.username,
                        password: newPassword,
                        onSuccess: {},
                        onFailure: { _ in }
                    )
                } else {
                    onSuccess()
                }
            },
            onFailure: { error in
                switch error {
                case .invalidCredentials:
                    onFailure("invalid password..")
                default:
                    onFailure("unable to update password.. try again later")
                }
            }
         )
     }
    
}

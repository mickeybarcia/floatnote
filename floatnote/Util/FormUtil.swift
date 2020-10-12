//
//  FormUtil.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/6/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation

/// Helpers for managing consistent form data
class FormUtil {
    
    static let INVALID_LOGIN_USERNAME_ERR = "invalid username or email.."
    static let INVALID_LOGIN_PASSWORD_ERR = "invalid password.."
    static let INVALID_PASSWORD_ERR = "password must be at least 6 characters.."
    static let INVALID_PASSWORDS_NOT_MATCH_ERR = "passwords must match.."
    static let INVALID_EMAIL_ERR = "must be a valid email.."
    static let INVALID_EMAILS_NOT_MATCH_ERR = "emails must match.."
    static let INVALID_USERNAME_ERR = "username must be at least 6 characters, and only contain letters and numbers.."
    static let INVALID_AGE_ERR = "must be a valid age.."
    static let USERNAME_MUST_BE_DIFFERENT_ERR = "new username must be different from the previous one.."
    static let EMAIL_MUST_BE_DIFFERENT_ERR = "new email must be different from the previous one.."
    static let PASSWORD_MUST_BE_NEW_ERR = "new password must be different.."
    
    /// Marks a username that is not alpanumeric
    /// - Parameter username
    /// - Returns: whether its valid
    static func isValidUsername(_ username: String) -> Bool {
        return username.count > 5 && username.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    /// Marks an email that is not an email
    /// - Parameter email
    /// - Returns: whether its valid
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.count > 0 && emailTest.evaluate(with: email)
    }
    
    /// Marks a password that isn't safe enough
    /// - Parameter password
    /// - Returns: whether its valid
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

}

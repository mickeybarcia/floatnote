//
//  FloatieError.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/15/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation

/// Mark types of app errors
public enum FloatieError: Error {

    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsupportedURL
    case usernameExists
    
    /// Map codes to type
    /// - Parameter errorCode: http code
    /// - Returns: the error object
    static func checkErrorCode(_ errorCode: Int) -> FloatieError {
        switch errorCode {
        case 500:
            return .serverError
        case 401:
            return .invalidCredentials
        default:
            return .unknownError
        }
    }

}

//
//  User.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/13/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation

/// The User model
public class User: Codable {
    
    var id: String?
    var password: String?
    var username: String
    var email: String
    var age: Int
    var gender: String?
    var mentalHealthStatus: String?
    var isVerified: Bool
    
    static func defaultUser() -> User {
        return User(
            username: "mickey",
            password: "mickey",
            email: "mickey",
            age: 100,
            gender: "mickey",
            mentalHealthStatus: "mickey",
            isVerified: true
        )
    }
    
    init(
        username: String,
        password: String,
        email: String,
        age: Int,
        gender: String?,
        mentalHealthStatus: String?,
        isVerified: Bool=false
    ) {
        self.username = username
        self.password = password
        self.email = email
        self.age = age
        self.gender = gender
        self.mentalHealthStatus = mentalHealthStatus
        self.isVerified = isVerified
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case password
        case username
        case email
        case age
        case gender
        case mentalHealthStatus
        case isVerified
    }
    
    /// Returns a dictionary for the  user request
    /// - Returns: the dictionary
    func toDictionary() -> [String: Any] {
        var params = [
            "username": username,
            "password": password,
            "email": email,
            "age": age
        ] as [String : Any]
        if let gender = gender, gender.count > 0 {
            params["gender"] = gender
        }
        if let mentalHealthStatus = mentalHealthStatus, mentalHealthStatus.count > 0 {
            params["mentalHealthStatus"] = mentalHealthStatus
        }
        return params
    }
    
}

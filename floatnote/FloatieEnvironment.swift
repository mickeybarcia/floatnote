//
//  FloatieEnvironment.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/10/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation

/// Config file for environment keys
public enum FloatieEnvironment {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let FLOATIE_SERVER_URL = "FLOATIE_SERVER_URL"
            static let CONFIGURATION = "Configuration"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let FLOATIE_SERVER_URL: String = {
        guard let FLOATIE_SERVER_URL = FloatieEnvironment.infoDictionary[Keys.Plist.FLOATIE_SERVER_URL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return FLOATIE_SERVER_URL
    }()
    
    static let CONFIGURATION: String = {
        guard let CONFIGURATION = FloatieEnvironment.infoDictionary[Keys.Plist.CONFIGURATION] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return CONFIGURATION
    }()
}

//
//  MockFloatieService.swift
//  floatnoteTests
//
//  Created by Michaela Barcia on 7/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import floatnote
import Foundation
import Alamofire

public class MockFloatieService: FloatieService { 

    var result: Any?
    
    public init() {
        super.init(floatieSession: Session.default)
    }
    
    public override func login( 
        usernameOrEmail: String,
        password: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (FloatieError) -> Void
    ) {
        if let error = self.result as? FloatieError {
            onFailure(error)
            return
        }
        onSuccess()
    }

}

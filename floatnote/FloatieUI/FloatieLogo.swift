//
//  FloatieLogo.swift
//  floatnote
//
//  Created by Michaela Barcia on 7/27/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation
import SwiftUI

class FloatieLogo {
    
    static var BIG_LOGO: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 120)
            .padding(50)
    }

}

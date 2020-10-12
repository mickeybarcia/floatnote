//
//  View+Dismiss.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/26/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

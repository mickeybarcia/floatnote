//
//  FloatieInfoBanner.swift
//  floatnote
//
//  Created by Michaela Barcia on 4/5/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Shows errors and info messages on views
struct FloatieBanner: View {
    
    /// Error text
    @Binding var errorMessage: String
    
    /// Message text
    @Binding var infoMessage: String
    
    var addHeaderSpace: Bool
    
    init(_ errorMessage: Binding<String> = Binding.constant(""), infoMessage: Binding<String> = Binding.constant(""), addHeaderSpace: Bool=true) {
        _errorMessage = errorMessage
        _infoMessage = infoMessage
        self.addHeaderSpace = addHeaderSpace
    }
    
    var body: some View {
        VStack {
            if self.errorMessage.count > 0 {
                FloatieErrorText(self.errorMessage)
            }
            if self.infoMessage.count > 0 {
                FloatieMessageText(self.infoMessage)
            }
        }.padding(self.addHeaderSpace ? 10 : 0)
    }

}

struct FloatieBanner_Previews: PreviewProvider {
    
    @State static var error = "here is the error message"
    @State static var info = ""

    static var previews: some View {
        FloatieBanner($error, infoMessage: $info)
    }
}

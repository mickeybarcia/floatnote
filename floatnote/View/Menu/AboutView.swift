//
//  AboutView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/28/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    let ABOUT_TEXT = "Here is all about Floate Note. Hello I am Mickey. Blah blah blah..."
    
    var body: some View {
        ZStack {
            Color.floatieBlue
            FloatieText(ABOUT_TEXT)
                .foregroundColor(Color.white)
                .padding(50)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

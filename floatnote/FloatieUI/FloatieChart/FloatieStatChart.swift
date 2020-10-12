//
//  FloatieStatChart.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/23/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// Displays a statistic number
struct FloatieStatChart: View {
    
    /// The label below
    let label: String
    
    /// The number value
    var value: Int
    
    /// The type of number value
    let statType: StatType
    
    /// The number formatted
    private var text: String {
        switch self.statType {
        case .percent:
            return String(value) + " %"
        }
    }
    
    var body: some View {
        VStack {
            Text(text).modifier(FloatieStatTextModifier())
            Text(label).modifier(FloatieStatLabelModifier())
        }.padding(10)
    }
    
}


/// Types of stats
enum StatType {
    case percent
}

/// Format the big stat number
struct FloatieStatTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FloatieFont.floatieBoldFont, size: 50))
            .foregroundColor(Color.white)
    }
}

/// Format the label below
struct FloatieStatLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(FloatieFont.floatieBoldFont, size: 20))
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
    }
}

struct FloatieStatChart_Previews: PreviewProvider {
    static var previews: some View {
        FloatieStatChart(label: "improvement rate", value: 10, statType: .percent).background(Color.blue)
    }
}

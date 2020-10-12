//
//  JournalRowView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The row displayed in the table
struct JournalRowView: View {
    
    var entry: Entry
    
    var body: some View {
        ZStack {
            Color.floatieDarkBlue.edgesIgnoringSafeArea(.all)
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    FloatieText(DateUtil.getEntryDisplayStringFromDate(date: entry.date))
                        .foregroundColor(.white)
                    FloatieSubTitle(entry.title)
                    FloatieText(entry.text)
                        .foregroundColor(.white)
                        .lineLimit(3)
                }
                Spacer()
            }.padding(5)
        }
    }

}

struct JournalRowView_Previews: PreviewProvider {
    static var previews: some View {
        JournalRowView(entry: Entry.default).previewLayout(.fixed(width: 500, height: 220))
    }
}

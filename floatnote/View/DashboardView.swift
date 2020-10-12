//
//  DashboardView.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI

/// The dashboard of the journal
struct DashboardView: View {
    
    @EnvironmentObject private var journal: JournalState

    var body: some View {
        ScrollView {
            ZStack {
                Color.floatieDarkBlue.edgesIgnoringSafeArea(.all)
                VStack(spacing: 10) {
                    FloatieBanner($journal.errorMessage, infoMessage: $journal.infoMessage)
                    VStack {
                        FloatieSubTitle("sentiment over time")
                        FloatieLineChart(
                            lineChartEntries: journal.lineChartEntries,
                            label: "sentiment over time",
                            xAxisValueFormatter: journal.xAxisFormatterLineChart
                        ).frame(height: 200)
                    }.padding()
                    HStack {
                        FloatieStatChart(
                            label: "avg sentiment",
                            value: journal.avgSentiment,
                            statType: .percent
                        )
                        FloatieStatChart(
                            label: "improvement",
                            value: journal.improvementRate,
                            statType: .percent
                        )
                    }.padding()
                    VStack {
                        FloatieSubTitle("key phrases")
                        FloatieBarChart(
                            barChartEntries: journal.barChartEntries,
                            label: "key phrases",
                            xAxisValueFormatter: journal.xAxisFormatterBarChart
                        ).frame(height: 200)
                    }.padding()
                    VStack {
                        FloatieSubTitle("summary")
                        if self.journal.summaryErrorMessage.count > 0 {
                            FloatieBanner(self.$journal.summaryErrorMessage)
                        } else {
                            FloatieText(journal.summary)
                                .foregroundColor(.white)
                                .lineLimit(40)
                                .padding(20)
                        }
                    }.padding()
                }
            }
        }.navigationBarTitle(Text("DASHBOARD"))
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView().environmentObject(JournalState())
    }
}

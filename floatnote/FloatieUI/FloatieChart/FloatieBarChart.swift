//
//  FloatieBarChart.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/23/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI
import Charts

/// Floatie wrapper around Charts bar charts
struct FloatieBarChart: UIViewRepresentable {

    /// The data in bar chart format
    var barChartEntries: [ChartDataEntry]

    /// The label of the dataset
    var label: String

    /// The formatter for the x axis
    var xAxisValueFormatter: IAxisValueFormatter
        
    /// The bar chart view formatted for Floatie
    var barChartView: BarChartView = {
        let view = BarChartView()
        view.rightAxis.enabled = false
        view.xAxis.labelPosition = .bottom
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.granularityEnabled = true
        view.xAxis.granularity = 1.0
        view.xAxis.labelFont = UIFont(name: FloatieFont.floatieFont, size: 10)!
        view.xAxis.labelTextColor = UIColor.white
        view.leftAxis.granularityEnabled = true
        view.leftAxis.granularity = 1.0
        view.leftAxis.drawGridLinesEnabled = false
        view.leftAxis.labelFont = UIFont(name: FloatieFont.floatieFont, size: 10)!
        view.leftAxis.labelTextColor = UIColor.white
        view.legend.textColor = UIColor.white
        view.xAxis.axisLineColor = UIColor.floatieDarkBlue!
        view.leftAxis.axisLineColor = UIColor.floatieDarkBlue!
        view.legend.enabled = false
        view.isUserInteractionEnabled = false
        return view
    }()

    func makeUIView(context: Context) -> BarChartView {
        return barChartView
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        let barChartDataSet = BarChartDataSet(entries: barChartEntries, label: label)
        let barChartData = BarChartData()
        barChartData.addDataSet(barChartDataSet)
        barChartData.setDrawValues(false)
        self.barChartView.data = barChartData
        self.barChartView.xAxis.valueFormatter = xAxisValueFormatter
        self.barChartView.data = barChartData
    }

}

/// X axis formatter for the keywords bar chart
class FloatieKeywordsChartFormatter: IAxisValueFormatter {

    /// The x axis keywords
    private var values: [String] = []

    convenience init(values: [String]) {
        self.init()
        self.values = values
    }

    /// Displays keywords
    /// - Parameters:
    ///   - value: keyward
    ///   - axis: x axis
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return values[Int(value)]
    }

}

// TODO - preview

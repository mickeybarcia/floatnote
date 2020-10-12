//
//  FloatieLineChart.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/23/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import SwiftUI
import Charts

/// Floatie wrapper around Charts line charts
struct FloatieLineChart: UIViewRepresentable {
    
    /// The data in line chart format
    var lineChartEntries: [ChartDataEntry]
    
    /// The label of the dataset
    var label: String
    
    /// The formatter for the x axis
    var xAxisValueFormatter: IAxisValueFormatter

    /// The line chart view formatted for Floatie
    var lineChartView: LineChartView = {
        let view = LineChartView()
        view.rightAxis.enabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.leftAxis.axisMinimum = 0;
        view.leftAxis.drawZeroLineEnabled = false //
        view.leftAxis.drawGridLinesEnabled = false
        view.leftAxis.labelFont = UIFont(name: FloatieFont.floatieFont, size: 10)!
        view.leftAxis.labelTextColor = UIColor.white
        view.xAxis.setLabelCount(4, force: true)
        view.xAxis.labelPosition = .bottom
        view.xAxis.drawLabelsEnabled = true
        view.xAxis.drawLimitLinesBehindDataEnabled = true
        view.xAxis.avoidFirstLastClippingEnabled = true
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.labelFont = UIFont(name: FloatieFont.floatieFont, size: 10)!
        view.xAxis.labelTextColor = UIColor.white
        view.legend.textColor = UIColor.white
        view.xAxis.axisLineColor = UIColor.floatieDarkBlue!
        view.leftAxis.axisLineColor = UIColor.floatieDarkBlue!
        view.legend.enabled = false
        view.isUserInteractionEnabled = false
        return view
    } ()
    
    func makeUIView(context: Context) -> LineChartView {
        return lineChartView
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntries, label: self.label)
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        let lineChartData = LineChartData()
        lineChartData.addDataSet(lineChartDataSet)
        self.lineChartView.xAxis.valueFormatter = xAxisValueFormatter
        self.lineChartView.data = lineChartData
    }
}


/// X axis formatter for the date
class FloatieXAxisDateFormatter: IAxisValueFormatter {
    
    /// The date formatter
    private var dateFormatter: DateFormatter?
    
    /// Used to generate x axis values
    private var referenceTimeInterval: TimeInterval?
    
    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter, let referenceTimeInterval = referenceTimeInterval else {
            return ""
        }
        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
    
}


struct FloatieLineChart_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

//
//  JournalViewModel.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation
import SwiftUI
import Charts

/// Manage state of the journal
final class JournalState: ObservableObject {
    
    /// The journal entries
    @Published private (set) var entries = [Entry]()

    /// The page of the journal
    @Published private (set) var page = 0
    
    /// If there are no more entries to load
    @Published private (set) var endOfJournal = false
    
    /// When to hide tab bar
    @Published var showFullScreen = false
    
    /// If the journal is loading
    @Published var isLoading = false
    
    /// The journal summary
    @Published var summary: String = ""
    @Published var summaryErrorMessage: String = ""
    
    // TODO - seperate dashboard logic from this file
    
    /// Sentiment data
    @Published var avgSentiment = 0
    @Published var improvementRate = 0
    
    /// Sentiment line chart data
    @Published var lineChartEntries: [ChartDataEntry] = []
    @Published var xAxisFormatterLineChart: IAxisValueFormatter =
        FloatieXAxisDateFormatter(
            referenceTimeInterval: 0,
            dateFormatter: DateUtil.lineGraphDateFormatter
        )
    
    /// Keywords data
    @Published var barChartEntries: [ChartDataEntry] = []
    @Published var xAxisFormatterBarChart: IAxisValueFormatter =
        FloatieKeywordsChartFormatter(values: [])
    
    @Published var errorMessage: String = ""
    @Published var infoMessage: String = ""
    
    private var service: FloatieService
    
    init(floatieService: FloatieService=FloatieService()) {
        self.service = floatieService
    }
    
    private func updateViewData() {  // TODO - use didSet like function
        if entries.count > 0 {
            self.entries.sort(by: { $0.date > $1.date })
            self.getSummary()
        } else {
            self.errorMessage = ""
            self.infoMessage = "no results found.."
        }
        self.loadDashboard()
    }
    
    /// Get entries
    /// - Parameters:
    ///   - startDate: startDate
    ///   - endDate: endDate
    ///   - onSuccess: adds journals
    func getEntries(
        startDate: Date?=nil,
        endDate: Date?=nil,
        onSuccess: @escaping () -> Void={}
    ) {
        isLoading = true
        page = page + 1
        if startDate != nil && endDate != nil {  // if you are setting a date, start over results
            page = 1
            entries = []
        }
        service.getEntries(
            startDate: startDate,
            endDate: endDate,
            page: page,
            onSuccess: { entries in
                if entries.entries.count < 10 {
                    self.endOfJournal = true
                }
                self.entries.append(contentsOf: entries.entries)  // append entries
                self.updateViewData()
                self.errorMessage = ""
                self.isLoading = false
                onSuccess()
            },
            onFailure: {
                self.endOfJournal = false
                self.errorMessage = "unable to load all journal entries.. try again later"
                self.page = max(0, self.page - 1)  // need to reload to try again
                self.isLoading = false
            }
        )
    }
    
    /// Add or update entry
    /// - Parameters:
    ///   - entry: entry
    ///   - onSuccess: update entry in list or add entry to list
    ///   - onFailure: return failure message
    func saveEntry(
        entry: Entry,
        onSuccess: @escaping (Entry) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        if let id = entry.id, let entryIndex = entries.firstIndex(where: { $0.id == entry.id }) {  // edit entry
            // TODO - send only updates
            service.editEntry(
                entry: entry,
                entryId: id,
                onSuccess: { newEntry in
                    self.entries[entryIndex] = newEntry
                    self.updateViewData()
                    onSuccess(newEntry)
                },
                onFailure: {
                   onFailure("unable to save entry.. try again later")
                }
            )
        } else {  // create a new entry
            service.createEntry(
                entry: entry,
                onSuccess: { newEntry in
                    self.entries.append(newEntry)
                    self.updateViewData()
                    onSuccess(newEntry)
                },
                onFailure: {
                    onFailure("unable to save entry.. try again later")
                }
            )
        }
    }
    
    /// Save images to the entry
    /// - Parameters:
    ///   - images: images
    ///   - entryId: entry id to update
    ///   - onSuccess: update entry and mark success
    ///   - onFailure: return failure message
    func saveImages(
        images: [UIImage],
        entryId: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        service.saveImages(
            images: images,
            entryId: entryId,
            onSuccess: { newEntry in
                if let entryIndex = self.entries.firstIndex(where: { $0.id == entryId }) {
                    self.entries[entryIndex] = newEntry
                    self.updateViewData()
                }
                onSuccess()
            },
            onFailure: { _ in
                onFailure("unable to save entry.. try again later")
            }
        )
    }
    
    func getSummary() {
        let endDate = entries[0].date
        let startDate = entries[entries.count - 1].date
        service.getSummary(
            startDate: startDate,
            endDate: endDate,
            onSuccess: { summary in
                if summary.count < 1 {
                    self.summaryErrorMessage = "not enough data for generating summary.."
                    return
                }
                self.summary = summary
                self.summaryErrorMessage = ""
            },
            onFailure: {
                self.summaryErrorMessage = "unable to load summary.. try again later"
            }
        )
    }
    
    /// Delete entry and update entries
    /// - Parameters:
    ///   - index: entry number
    ///   - onFailure: return failure message
    func deleteEntry(
        index: Int,
        onFailure: @escaping (String) -> Void
    ) {
        if let entryId = entries[index].id {
            service.deleteEntry(
                entryId: entryId,
                onSuccess: {
                    self.entries.remove(at: index)
                    self.updateViewData()
                },
                onFailure: {
                    onFailure("unable to delete entry.. try again later")
                }
            )
        }
    }
    
    /// Load and format the data for the dashboard
    private func loadDashboard() {
        loadSentimentStats()
        loadSentimentChart()
        loadKeywordBarChart()
    }
    
    /// Load sentiment numbers
    private func loadSentimentStats() {
        var totalScore = Float(0)
        for entry in entries {
            if let score = entry.score {
                totalScore = totalScore + score
            }
        }
        if entries.count > 0 {
            avgSentiment = Int(totalScore / Float(entries.count) * 100)
        }
        if entries.count > 1, let beforeScore = entries[entries.count - 1].score, let afterScore = entries[0].score {
            improvementRate = Int((afterScore - beforeScore) / Float(entries.count) * 100)
        }
    }
    
    /// Load sentiment chart entries
    private func loadSentimentChart() {
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (entries.map { $0.date.timeIntervalSince1970 }).min() {
            referenceTimeInterval = minTimeInterval
        }
        
        self.xAxisFormatterLineChart = FloatieXAxisDateFormatter(
            referenceTimeInterval: referenceTimeInterval,
            dateFormatter: DateUtil.lineGraphDateFormatter
        )
        
        var newLineChartEntries = [ChartDataEntry]()
        for entry in entries.sorted(by: {$0.date.compare($1.date) == .orderedAscending}) {
            if let score = entry.score {
                let timeInterval = entry.date.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                let yValue = Double(score)
                let lineChartEntry = ChartDataEntry(x: xValue, y: yValue)
                newLineChartEntries.append(lineChartEntry)
            }
        }
        self.lineChartEntries = newLineChartEntries
    }
    
    /// Load keyword data entries
    private func loadKeywordBarChart() {
        var keywordCounts: [String: Int] = [:]
        for entry in entries {
            if let keywords = entry.keywords {
                for keyword in keywords {
                    if keyword.count < 10 {
                        if Array(keywordCounts.keys).contains(keyword), let count = keywordCounts[keyword] {
                            keywordCounts[keyword] = count + 1
                        } else {
                            keywordCounts[keyword] = 1
                        }
                    }
                }
            }
        }
        
        let numKeywords = min(3, keywordCounts.count - 1)
        if numKeywords > 0 {
            let keywords = Array(keywordCounts.sorted { $0.1 > $1.1 }.map{ $0.0 }[0...numKeywords])  // Get top 5 most popular keywords
            var newBarChartEntries = [ChartDataEntry]()
            for i in 0 ..< keywords.count {
                if let count = keywordCounts[keywords[i]] {
                    let barChartEntry = BarChartDataEntry(x: Double(i), y: Double(count))
                        newBarChartEntries.append(barChartEntry)
                }
            }
            self.barChartEntries = newBarChartEntries
            self.xAxisFormatterBarChart = FloatieKeywordsChartFormatter(values: keywords)
        }
    }
    
}

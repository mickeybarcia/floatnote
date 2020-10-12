//
//  DateUtil.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/19/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation

/// Formats and formulates dates for our use cases
class DateUtil {
    
    /// Date format to decode entry dates from the backend
    static var entryJsonDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
    
    /// Formats dates shown in the line graph
    static var lineGraphDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy h a"
        return formatter
    }
    
    /// Formats the entry date to display in the journal
    /// - Parameter date: the entry date
    /// - Returns: the display string
    static func getEntryDisplayStringFromDate(date: Date) -> String {
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MMM d yyyy h:mm a"
        return displayDateFormatter.string(from: date)
    }
    
    /// Formats the entry date to display in the journal in month and year
    /// - Parameter date: the entry date
    /// - Returns: the display string
    static func getShortEntryDisplayStringFromDate(date: Date) -> String {
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MMM yyyy"
        return displayDateFormatter.string(from: date)
    }
    
    /// Formats the entry date to send to the backend
    /// - Parameter date: the entry date
    /// - Returns: the request string
    static func getEntryRequestStringFromDate(date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]
        return formatter.string(from: date)
    }

}

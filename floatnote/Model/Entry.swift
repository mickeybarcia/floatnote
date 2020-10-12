//
//  Entry.swift
//  floatnote
//
//  Created by Michaela Barcia on 3/18/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation

/// The entry model
struct Entry: Identifiable, Codable {
    
    var id: String?
    let title: String
    let date: Date
    var text: String
    var form: Format
    var score: Float?
    var keywords: Array<String>?
    var imageUrls: Array<String>?
    
    static let `default` =  Self(
           title: "Corona has taken over..",
           text: "sad sad sad sad I am so sad sad sad I said I'm sad sad sad like SAD SAD SAD !! You see I'm a sad sad sad sad sad sad SAD and I'm sad sad SAD!!!!!!  So sad.. sad sad",
           form: .text,
           date: Date()
    )
    
    static let display =  Self(
           title: "",
           text: "type your entry here or change the format or change the format to image to take pictures of your journal",
           form: .text,
           date: Date()
    )

    init(
        title: String,
        text: String,
        form: Format,
        date: Date
    ) {
        self.title = title
        self.text = text
        self.form = form
        self.date = date
    }

    init(
        id: String?,
        title: String,
        text: String,
        form: Format,
        date: Date
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.form = form
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
        case text
        case form
        case score
        case keywords
        case imageUrls
    }
    
    /// Returns a dictionary for the entry request
    /// - Returns: the disctionary
    func toDictionary() -> [String: String] {
        return [
            "title": title,
            "date": DateUtil.entryJsonDateFormatter.string(from: date),
            "form": self.form.rawValue,
            "text":  self.text,
        ]
    }
    
}

/// Represents the entry list response
struct Entries: Decodable {
  let entries: [Entry]
  
  enum CodingKeys: String, CodingKey {
    case entries
  }
}

enum Format: String, Codable {
    case text
    case image
}

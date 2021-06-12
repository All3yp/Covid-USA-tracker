//
//  Extension.swift
//  Covid Tracker
//
//  Created by Alley Pereira on 11/06/21.
//

import Foundation

extension DateFormatter {
    static let brazilianDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()

    static let americanDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()

    static let prettyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }()
}

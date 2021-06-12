//
//  Models.swift
//  Covid Tracker
//
//  Created by Alley Pereira on 10/06/21.
//

import Foundation

struct StateListResponse: Codable {
    let data: [State]
}

struct State: Codable {
    let name: String
    let state_code: String
}

struct CovidDataResponse: Codable {
    let data: [CovidDayData]
}

struct CovidDayData: Codable {
    let cases: CovidCases?
    let date: String
}

struct CovidCases: Codable {
    let total: TodalCases
}

struct TodalCases: Codable {
    let value: Int?
}

struct DayData {
    let date: String
    let count: Int
}

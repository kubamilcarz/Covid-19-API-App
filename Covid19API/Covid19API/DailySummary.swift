//
//  DailySummary.swift
//  Covid19API
//
//  Created by Kuba Milcarz on 11/12/2021.
//

import Foundation

struct DailySummary: Codable {
    let ID: String
    let Message: String
    let Global: GlobalDailySummary
    var Countries: [CountryDailySummary]
    let Date: String
}

struct GlobalDailySummary: Codable {
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int
    let Date: String
}

struct CountryDailySummary: Codable {
    let ID: String
    let Country: String
    let CountryCode: String
    let Slug: String
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int
    let Date: String
}

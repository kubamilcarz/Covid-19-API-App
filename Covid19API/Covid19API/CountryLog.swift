//
//  CountryLog.swift
//  Covid19API
//
//  Created by Kuba Milcarz on 11/12/2021.
//

import Foundation

struct CountryDailyCases: Codable {
    let ID: String
    let Country: String
    let CountryCode: String
    let Province: String
    let City: String
    let CityCode: String
    let Lat: String
    let Lon: String
    let Confirmed: Int
    let Deaths: Int
    let Recovered: Int
    let Active: Int
    let Date: Date
}

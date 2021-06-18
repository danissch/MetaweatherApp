//
//  WeatherModel.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Decodable {
    let id: Int
    let weatherStateName: WeatherStateName
    let weatherStateAbbr: WeatherStateAbbr
    let windDirectionCompass: WindDirectionCompass
    let created, applicableDate: String
    let minTemp, maxTemp, theTemp, windSpeed: Double?
    let windDirection: Double
    let airPressure, humidity: Int?
    let visibility: Double?
    let predictability: Int

    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability
    }
}

enum WeatherStateAbbr: String, Decodable {
    case c = "c"
    case lc = "lc"
}

enum WeatherStateName: String, Decodable {
    case clear = "Clear"
    case lightCloud = "Light Cloud"
}

enum WindDirectionCompass: String, Decodable {
    case nnw = "NNW"
    case nw = "NW"
    case windDirectionCompassFalse = "False"
    case wnw = "WNW"
}


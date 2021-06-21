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
    let weatherStateName: String
    let weatherStateAbbr: String
    let windDirectionCompass: String
    let created, applicableDate: String
    let minTemp, maxTemp, theTemp, windSpeed: Double?
    let windDirection: Double
    let humidity: Int?
    let airPressure, visibility: Double?
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

class WeatherModelUtil {
    static let shared = WeatherModelUtil()
    func getEmptyWeatherObject() -> WeatherModel {
        return WeatherModel(id: 0, weatherStateName: "", weatherStateAbbr: "", windDirectionCompass: "", created: "", applicableDate: "", minTemp: 0, maxTemp: 0, theTemp: 0, windSpeed: 0, windDirection: 0, humidity: 0, airPressure: 0, visibility: 0, predictability: 0)
    }
}

//
//  ApiPaths.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation

struct ApiPaths {
    static let shared = ApiPaths()
    let locationSearchUrl = "https://www.metaweather.com/api/location/search/?query="
    let weatherLocationUrl = "https://www.metaweather.com/api/location/"
    let defaultImageUrl = "https://www.metaweather.com/static/img/weather/png/c.png"
    let iconsPng64x64Url = "https://www.metaweather.com/static/img/weather/png/64/"
    
}

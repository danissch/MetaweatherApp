//
//  LocationSearchModel.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

// To parse the JSON, add this file to your project and do:
//
//   let locationSearchModel = try LocationSearchModel(json)

import Foundation

// MARK: - LocationSearchModel
struct LocationSearchModel: Decodable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

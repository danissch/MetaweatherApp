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
//
//// MARK: LocationSearchModel convenience initializers and mutators
//
//extension LocationSearchModel {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(LocationSearchModel.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        title: String? = nil,
//        locationType: String? = nil,
//        woeid: Int? = nil,
//        lattLong: String? = nil
//    ) -> LocationSearchModel {
//        return LocationSearchModel(
//            title: title ?? self.title,
//            locationType: locationType ?? self.locationType,
//            woeid: woeid ?? self.woeid,
//            lattLong: lattLong ?? self.lattLong
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//typealias LocationSearchModel = [LocationSearchModel]
//
//extension Array where Element == LocationSearchModel.Element {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(LocationSearchModel.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//// MARK: - Helper functions for creating encoders and decoders
//
//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}

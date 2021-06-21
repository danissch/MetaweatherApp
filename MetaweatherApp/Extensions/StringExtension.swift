//
//  StringExtension.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

extension String {
    func getImageUrlFromString() -> URL {
        guard let urlImage = URL(string: self) else {
            return URL(string: ApiPaths.shared.defaultImageUrl)!
        }
        return urlImage
    }
    
    func getApiUrlFromString() -> URL {
        guard let urlFromString = URL(string: self) else {
            return URL(string: "")!
        }
        return urlFromString
    }
    
    //format: "yyyy-MM-dd HH:mm:ss"
    func toDate(withFormat format: String = "yyyy-MM-dd", timezone: String = "America/Bogota")-> Date?{
        let dateFormatter = DateFormatter()
        print("toDate:timezone::\(timezone)")
        print("toDate:format::\(format)")
        print("toDate:self::\(self)")
//        dateFormatter.timeZone = TimeZone(identifier: timezone)
//        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }
    
    
}

//
//  DateExtension.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 19/06/21.
//

import Foundation

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func getDate(dayDifference: Int) -> Date{
        var components = DateComponents()
        components.day = dayDifference
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "America/Bogota")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
    
    func getTodaysDateString(format: String = "yyyy-MM-dd") -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func getTomorrowDateString(format: String = "yyyy-MM-dd") -> String {
//        let date = Date()
        let tomorrow = Date().getDate(dayDifference: 1)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: tomorrow)
    }
    
}

//
//  LocationDetailViewModelProtocol.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

protocol LocationDetailViewModelProtocol {
    var weatherLocationDetail: [WeatherLocationModel] { get }
    func getWeatherLocationDetail(woeid: String, completion: @escaping (ServiceResult<[WeatherLocationModel]?>) -> Void)
}

//
//  LocationDetailViewModelProtocol.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

protocol LocationDetailViewModelProtocol {
    var weatherLocationDetail: [WeatherLocationModel] { get }
    var todaysWeather: [WeatherModel] { get }
    var selectedWeather: [Int] { get set }
    func getWeatherLocationDetail(woeid: String, completion: @escaping (ServiceResult<[WeatherLocationModel]?>) -> Void)
    func getWeatherByDate(woeidPlusDateString: String, completion: @escaping (ServiceResult<[WeatherModel]?>) -> Void)
    func getSelectedWeather() -> WeatherModel
}

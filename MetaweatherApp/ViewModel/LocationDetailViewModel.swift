//
//  LocationDetailViewModel.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

protocol LocationDetailViewModelDelegate {
    func onSelectedWeather()
}

class LocationDetailViewModel: LocationDetailViewModelProtocol {
    
    var networkService: NetworkServiceProtocol?
    var delegate:LocationDetailViewModelDelegate?
    
    private var privWeatherLocationDetail = [WeatherLocationModel]()
    var weatherLocationDetail: [WeatherLocationModel] {
        get {
            return privWeatherLocationDetail
        }
    }
    
    private var privTodaysWeather = [WeatherModel]()
    var todaysWeather: [WeatherModel] {
        get {
            return privTodaysWeather
        }
    }
    
    private var privSelectedWeather = [0]
    var selectedWeather: [Int] {
        get {
            return privSelectedWeather
        }
        set {
            privSelectedWeather = newValue
            if newValue[0] != 0 {
                delegate?.onSelectedWeather()
            }
        }
    }
    
    init(){}
    
    func getWeatherLocationDetail(woeid: String, completion: @escaping (ServiceResult<[WeatherLocationModel]?>) -> Void) {
        guard let networkService = networkService else {
            return completion(.Error("Missing network service", 0))
        }
        
        let url = "\(ApiPaths.shared.weatherLocationUrl)\(woeid)"
        networkService.request(url: url, method: .get, parameters: nil){ [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .Success(let json, let statusCode):
                do {
                    if let data = json?.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let weatherLocationResponse = try decoder.decode(WeatherLocationModel.self, from: data)
                        self.privWeatherLocationDetail = [weatherLocationResponse]
                        return completion(.Success(self.privWeatherLocationDetail, statusCode))
                    }
                    return completion(.Error("Error parsing data", statusCode))
                } catch {
                    print("error:\(error)")
                    return completion(.Error("Error decoding JSON", statusCode))
                }
            case .Error(let message, let statusCode):
                print("case .Error :: getWeatherLocationDetail")
                return completion(.Error(message, statusCode))
            }
            
        }
        
    }
    
    
    func getWeatherByDate(woeidPlusDateString: String, completion: @escaping (ServiceResult<[WeatherModel]?>) -> Void) {
        guard let networkService = networkService else {
            return completion(.Error("Missing network service", 0))
        }
        
        let url = "\(ApiPaths.shared.weatherLocationUrl)\(woeidPlusDateString)"
        networkService.request(url: url, method: .get, parameters: nil){ [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .Success(let json, let statusCode):
                do {
                    if let data = json?.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let weatherModelResponse = try decoder.decode([WeatherModel].self, from: data)
                        self.privTodaysWeather = weatherModelResponse
                        return completion(.Success(self.privTodaysWeather, statusCode))
                    }
                    return completion(.Error("Error parsing data", statusCode))
                } catch {
                    print("error:\(error)")
                    return completion(.Error("Error decoding JSON", statusCode))
                }
            case .Error(let message, let statusCode):
                print("case .Error :: getWeatherByDate")
                return completion(.Error(message, statusCode))
            }
            
        }
        
    }
    
    
    func getSelectedWeather() -> WeatherModel {
        
        guard let todaysWeatherId = todaysWeather.first else {
            return WeatherModelUtil.shared.getEmptyWeatherObject()
        }
        if selectedWeather[0] == todaysWeatherId.id {
            return todaysWeather[0]
        }
        let weatherTodayIndex = weatherLocationDetail[0].consolidatedWeather.firstIndex(where: {$0.id == selectedWeather[0]})

        if let index = weatherTodayIndex {
            let weatherTodayObject = weatherLocationDetail[0].consolidatedWeather[index]
            return weatherTodayObject
        }
        return WeatherModelUtil.shared.getEmptyWeatherObject()
        
        
    }
    
}

//
//  LocationDetailViewModel.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

class LocationDetailViewModel: LocationDetailViewModelProtocol {
    
    var networkService: NetworkServiceProtocol?
    
    private var privWeatherLocationDetail = [WeatherLocationModel]()
    var weatherLocationDetail: [WeatherLocationModel] {
        get {
            return privWeatherLocationDetail
        }
    }
    
    init(){}
    
    func getWeatherLocationDetail(woeid: String, completion: @escaping (ServiceResult<[WeatherLocationModel]?>) -> Void) {
        guard let networkService = networkService else {
            return completion(.Error("Missing network service", 0))
        }
        
        let url = "\(ApiPaths.shared.locationSearchUrl)"
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
//                        self.privLocationSearchList.append(contentsOf: locationSearchResponse)
                        self.privWeatherLocationDetail = [weatherLocationResponse]
                        return completion(.Success(self.privWeatherLocationDetail, statusCode))
                    }
                    return completion(.Error("Error parsing data", statusCode))
                } catch {
                    print("error:\(error)")
                    return completion(.Error("Error decoding JSON", statusCode))
                }
            case .Error(let message, let statusCode):
                print("case .Error :: searchByTerm")
                return completion(.Error(message, statusCode))
            }
            
        }
        
    }
    
    
}

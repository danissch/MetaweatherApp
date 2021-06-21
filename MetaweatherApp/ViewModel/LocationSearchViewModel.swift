//
//  LocationSearchViewModel.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

class LocationSearchViewModel: LocationSearchViewModelProtocol {
    
    var networkService: NetworkServiceProtocol?
    
    private var privLocationSearchList = [LocationSearchModel]()
    var locationSearchList: [LocationSearchModel] {
            get { return privLocationSearchList }
        }
    
    private var privFilteredLocationSearchList = [LocationSearchModel]()
    var filteredLocationSearchList: [LocationSearchModel] {
        get { return privFilteredLocationSearchList }
        set { privFilteredLocationSearchList = newValue}
    }
    
    init(){}
    
    
    func searchByTerm(termToSearch: String, completion: @escaping (ServiceResult<[LocationSearchModel]?>) -> Void) {
        guard let networkService = networkService else {
            return completion(.Error("Missing network service", 0))
        }
        
        if termToSearch == "" {
            resetLists()
            return
        }
        
        let url = "\(ApiPaths.shared.locationSearchUrl)\(termToSearch)"
        networkService.request(url: url, method: .get, parameters: nil){ [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .Success(let json, let statusCode):
                do {
                    if let data = json?.data(using: .utf8) {
                        let decoder = JSONDecoder()
                        let locationSearchResponse = try decoder.decode([LocationSearchModel].self, from: data)
                        self.privLocationSearchList = locationSearchResponse
                        return completion(.Success(self.privLocationSearchList, statusCode))
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
    
    func resetLists(){
        self.privLocationSearchList = []
        self.privFilteredLocationSearchList = []
    }
    
}

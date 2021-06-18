//
//  LocationSearchViewModelProtocol.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation

protocol LocationSearchViewModelProtocol {
    var locationSearchList: [LocationSearchModel] { get }
    var filteredLocationSearchList: [LocationSearchModel] { set get }
    
    func searchByTerm(termToSearch: String, completion: @escaping (ServiceResult<[LocationSearchModel]?>) -> Void)
    func resetLists()
}

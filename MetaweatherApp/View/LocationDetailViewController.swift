//
//  LocationDetailViewController.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation
import UIKit

class LocationDetailViewController: UIViewController {
    
    private var locationSearchModel: LocationSearchModel?
    private var locationDetailViewModel: LocationDetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        self.view.backgroundColor = .green
        setupViewModel()
        
    }
    
    
    
    
    
}

extension LocationDetailViewController {
    func setControllerData(locationSearchModel: LocationSearchModel){
        self.locationSearchModel = locationSearchModel
        self.title = "Weather details for \(locationSearchModel.title)"
    }
    
    func setupViewModel(){
        let locationDetailViewModel = LocationDetailViewModel()
        NetworkService.get.afSessionManager = AFSessionManager()
        locationDetailViewModel.networkService = NetworkService.get
        self.locationDetailViewModel = locationDetailViewModel as LocationDetailViewModelProtocol
    }
}

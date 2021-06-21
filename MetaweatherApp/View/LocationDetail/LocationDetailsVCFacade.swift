//
//  LocationDetailsVCFacade.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 18/06/21.
//

import Foundation
import UIKit
import Kingfisher
import CoreLocation
import MapKit

class LocationDetailsVCFacade {
    
    let locationDetailVC: LocationDetailViewController
    let weatherLocationObject: WeatherLocationModel
    let todaysWeather: [WeatherModel]
    var locationDetailViewModel: LocationDetailViewModelProtocol
    
    var weatherPronosticBarView = WeatherPronosticBarView.instanceFromNib() as! WeatherPronosticBarView
    var weatherPronosticStackView: UIStackView!
    var viewsForStack: [UIView] = []
    
    init(vc:LocationDetailViewController, weatherLocationObject: WeatherLocationModel, todaysWeather: [WeatherModel], locationDetailViewModel: LocationDetailViewModelProtocol) {
        self.locationDetailVC = vc
        self.weatherLocationObject = weatherLocationObject
        self.todaysWeather = todaysWeather
        self.locationDetailViewModel = locationDetailViewModel
    }
    
    func setHeaderData(tapFromBar: Bool = false){
        setWeatherStateName()
        setTodaysWeatherIcon()
        setMapLocation()
        setTodaysDateOnBoard()
        setTodaysTemp()
        setTodaysWindSpeed()
        setTodaysHumidity()
        if !tapFromBar {
            setViewsToHeaderStackView()
        }
        
    }
    
    private func setWeatherStateName(){
        locationDetailVC.weatherLocationTitle.text = locationDetailViewModel.getSelectedWeather().weatherStateName
        locationDetailVC.weatherLocationTitle.fadeIn()
        locationDetailVC.weatherLocationTitle.isHidden = false
        setWeatherNameAtHeader()
    }
    
    private func setTodaysTemp(){
        var normalTemp = String(format: "%.0f", locationDetailViewModel.getSelectedWeather().theTemp!)
        normalTemp.append("°")
        locationDetailVC.weatherLocationTempLabel.text = normalTemp
    }
    
    private func setTodaysWindSpeed(){
        let normalWindSpeed = String(format: "%.1f", locationDetailViewModel.getSelectedWeather().windSpeed!)
        locationDetailVC.windSpeedLabel.text = normalWindSpeed
    }
    
    private func setTodaysHumidity(){
        let normalHumidity = locationDetailViewModel.getSelectedWeather().humidity?.description
        locationDetailVC.humidityLabel.text = normalHumidity
    }
    
    private func setTodaysWeatherIcon(){
        locationDetailVC.todaysWeatherIcon.kf.setImage(with: getTodaysWeatheIconUrl().getImageUrlFromString())
        locationDetailVC.headerWeatherImageView.kf.setImage(with: getTodaysWeatheIconUrl().getImageUrlFromString())
    }
    
    private func setTodaysDateOnBoard(){
        locationDetailVC.dateOnBoardLabel.text = locationDetailViewModel.getSelectedWeather().applicableDate
    }
    
    private func setWeatherNameAtHeader(){
        self.locationDetailVC.headerWeatherName.text = locationDetailVC.weatherLocationTitle.text
    }
    
    private func setMapLocation(){
        locationDetailVC.mapView.centerToLocation(processLocation())
    }
    
    func setViewsToHeaderStackView(){
        addTodaysButtonPronosticBar()
        
        let countWeatherModels = weatherLocationObject.consolidatedWeather.count
        print("countWeatherModels:: \(countWeatherModels)")
        var countProcessor = 0
        
        weatherLocationObject.consolidatedWeather.forEach({ weather in
            if countProcessor == 5 {
                addViewsToStackView()
                return
            }
            
            if weather.applicableDate == getTodaysConsolidatedWeatherObject().applicableDate {
                return
            }

            weatherPronosticBarView = WeatherPronosticBarView(frame: CGRect(x: 0, y: 2, width: (locationDetailVC.weatherPronosticStackView.bounds.width / CGFloat(countWeatherModels)), height: locationDetailVC.weatherPronosticStackView.bounds.height))
            
            let dayString = "\(self.getDayNameFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))  \(self.getDayNumberFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))"
            weatherPronosticBarView.setWeatherData(weather: weather, locationDetailViewModel: locationDetailViewModel, iconUrl: getIconUrlStringFromWeather(weather: weather), dayString: dayString, action: {
                print("Hola soy el weather del dia \(self.getDayNameFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))  \(self.getDayNumberFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))")
                self.locationDetailViewModel.selectedWeather[0] = weather.id
                self.removeViewsFromStackView()
                self.setViewsToHeaderStackView()
                
            })
            
            viewsForStack.append(weatherPronosticBarView)
            countProcessor += 1
        })
    }
    
    private func addTodaysButtonPronosticBar(){
        let countWeatherModels = weatherLocationObject.consolidatedWeather.count
        let weather = getTodaysConsolidatedWeatherObject()
        if locationDetailViewModel.selectedWeather[0] == 0 {
            locationDetailViewModel.selectedWeather[0] = getTodaysConsolidatedWeatherObject().id
        }
        
        weatherPronosticBarView = WeatherPronosticBarView(frame: CGRect(x: 0, y: 2, width: (locationDetailVC.weatherPronosticStackView.bounds.width / CGFloat(countWeatherModels)), height: locationDetailVC.weatherPronosticStackView.bounds.height))
        let dayString = "\(self.getDayNameFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))  \(self.getDayNumberFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))"
        weatherPronosticBarView.setWeatherData(weather: weather, locationDetailViewModel: locationDetailViewModel, iconUrl: getIconUrlStringFromWeather(weather: weather), dayString: dayString, action: {
            
            print("Hola soy el weather del dia \(self.getDayNameFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))  \(self.getDayNumberFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))")
            self.locationDetailViewModel.selectedWeather[0] = weather.id
            self.removeViewsFromStackView()
            self.setViewsToHeaderStackView()
        })
        
        viewsForStack.append(weatherPronosticBarView)
    }
    
    private func addViewsToStackView(){
        viewsForStack.forEach({ weatherView in
            locationDetailVC.weatherPronosticStackView.addArrangedSubview(weatherView)

        })
    }
    
    private func removeViewsFromStackView(){
        viewsForStack.forEach({ weatherView in
            locationDetailVC.weatherPronosticStackView.removeArrangedSubview(weatherView)
        })
        viewsForStack = []
    }
    
}

extension LocationDetailsVCFacade {
    private func getIconUrlStringFromWeather(weather: WeatherModel) -> String {
        return "\(ApiPaths.shared.iconsPng64x64Url)\(weather.weatherStateAbbr).png"
    }
    
    private func getTodaysWeatheIconUrl() -> String {
        return "\(ApiPaths.shared.iconsPng64x64Url)\(locationDetailViewModel.getSelectedWeather().weatherStateAbbr).png"
    }
}

extension LocationDetailsVCFacade {
    
    private func getTodaysConsolidatedWeatherObject() -> WeatherModel {
        if let weatherTodaysObject = todaysWeather.first {
            return weatherTodaysObject
        }
        return WeatherModelUtil.shared.getEmptyWeatherObject()
    }
    
    private func getTomorrowConsolidatedWeatherObject() -> WeatherModel {
        print("getTomorrowDateString:.: \(Date().getTomorrowDateString())")
        let weatherTodayIndex = weatherLocationObject.consolidatedWeather.firstIndex(where: {$0.applicableDate == Date().getTomorrowDateString()})

        if let index = weatherTodayIndex {
            let weatherTodayObject = weatherLocationObject.consolidatedWeather[index]
            return weatherTodayObject
        }
        return WeatherModelUtil.shared.getEmptyWeatherObject()
        
    }
    
    func getDayNameFromString(dateInString: String, timezone: String) -> String {
        print("getDayNameFromString:: dateInString:: \(dateInString)")
        guard let dateFromString = dateInString.toDate(timezone: timezone) else {
            return "No day"
        }
        print("getDayNameFromString:: dateFromString:: \(dateFromString)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayInWeek = dateFormatter.string(from: dateFromString)
        return dayInWeek
    }
    
    func getDayNumberFromString(dateInString: String, timezone: String) -> String {
        guard let dateFromString = dateInString.toDate(timezone: timezone) else {
            return "No day"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayInWeek = dateFormatter.string(from: dateFromString)
        return dayInWeek
    }
    
    private func processLocation() ->  CLLocation {
        print(weatherLocationObject.lattLong)
        print(type(of: weatherLocationObject.lattLong))
        let splittedWeatherLocation = weatherLocationObject.lattLong.split(separator: ",")
        print(splittedWeatherLocation)
        print(type(of: splittedWeatherLocation))
        let latt = (splittedWeatherLocation[0] as NSString).doubleValue
        let long = (splittedWeatherLocation[1] as NSString).doubleValue
        let center = CLLocationCoordinate2D(latitude: latt, longitude: long)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: latt, longitudinalMeters: long)
        
        let initialLocation = CLLocation(latitude: latt, longitude: long)
        
        return initialLocation
    }
    
 
}

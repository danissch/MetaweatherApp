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
    
    
    var weatherPronosticStackView: UIStackView!
    var viewsForStack: [UIView] = []
    let baseNumberOfDaysToPredict = 4
    var numberOfDaysToPredict = 4
    var pronosticBarStackView: UIStackView?
    
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
//        locationDetailVC.weatherLocationTitle.fadeIn()
//        locationDetailVC.weatherLocationTitle.isHidden = false
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
        var countProcessor = 0
        weatherLocationObject.consolidatedWeather.forEach({ weather in
            print("appflow:: setViewsToHeaderStackView countProcessor: \(countProcessor)")
            print("appflow:: setViewsToHeaderStackView weather.applicableDate: \(weather.applicableDate)")
            if countProcessor == numberOfDaysToPredict {
                return
            }
            if countProcessor == 0, weather.applicableDate == getTodaysConsolidatedWeatherObject().applicableDate {
                addTodaysButtonPronosticBar()
                countProcessor += 1
                numberOfDaysToPredict += 1
                return
//                locationDetailViewModel.selectedWeather[0] = weather.id
                
            } else if countProcessor == 0, weather.applicableDate != getTodaysConsolidatedWeatherObject().applicableDate {
                addTodaysButtonPronosticBar()
            }
            viewsForStack.append(produceButtonPronosticBar(weather: weather))
            countProcessor += 1
        })
        addViewsToStackView()
        print("appflow::setViewsToHeaderStackView viewsForStack.count: \(viewsForStack.count)")
        numberOfDaysToPredict = baseNumberOfDaysToPredict
    }
    
    private func addTodaysButtonPronosticBar(){
        let weather = getTodaysConsolidatedWeatherObject()
        if locationDetailViewModel.selectedWeather[0] == 0 {
            locationDetailViewModel.selectedWeather[0] = getTodaysConsolidatedWeatherObject().id
        }
        viewsForStack.append(produceButtonPronosticBar(weather: weather))
        print("appflow::addTodaysButtonPronosticBar::viewsForStack.count \(viewsForStack.count)")
    }
    
    private func addViewsToStackView(){
//        let stackView = pronosticBarStackView
//        locationDetailVC.view.addSubview(stackView ?? UIStackView())
//        locationDetailVC.weatherPronosticStackView = stackView
        viewsForStack.forEach({ weatherView in
            locationDetailVC.weatherPronosticStackView.addArrangedSubview(weatherView)

        })
    }
    
    private func removeViewsFromStackView(){
        viewsForStack.forEach({ weatherView in
            locationDetailVC.weatherPronosticStackView.removeArrangedSubview(weatherView)
//        locationDetailVC.weatherPronosticStackView.removeFromSuperview()
            weatherView.removeFromSuperview()

        })
        viewsForStack = []
    }
    
    
    func produceButtonPronosticBar(weather: WeatherModel) -> WeatherPronosticBarView {
        let countWeatherModels = weatherLocationObject.consolidatedWeather.count
        var todaysWeatherPronosticBarView = WeatherPronosticBarView.instanceFromNib() as! WeatherPronosticBarView
        todaysWeatherPronosticBarView = WeatherPronosticBarView(frame: CGRect(x: 0, y: 2, width: (locationDetailVC.weatherPronosticStackView.bounds.width / CGFloat(countWeatherModels)), height: locationDetailVC.weatherPronosticStackView.bounds.height))
        let dayString = "\(self.getDayNameFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))  \(self.getDayNumberFromString(dateInString: weather.applicableDate, timezone: self.weatherLocationObject.timezone))"
        todaysWeatherPronosticBarView.setWeatherData(weather: weather, locationDetailViewModel: locationDetailViewModel, iconUrl: getIconUrlStringFromWeather(weather: weather), dayString: dayString, action: {
            
            self.actionsForButtonPronosticBar(weather: weather)
            
        })
        
        return todaysWeatherPronosticBarView
        
    }
    
    func actionsForButtonPronosticBar(weather: WeatherModel){
        self.locationDetailViewModel.selectedWeather[0] = weather.id
        self.removeViewsFromStackView()
        self.setViewsToHeaderStackView()
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
        let weatherTodayIndex = weatherLocationObject.consolidatedWeather.firstIndex(where: {$0.applicableDate == Date().getTomorrowDateString()})

        if let index = weatherTodayIndex {
            let weatherTodayObject = weatherLocationObject.consolidatedWeather[index]
            return weatherTodayObject
        }
        return WeatherModelUtil.shared.getEmptyWeatherObject()
        
    }
    
    func getDayNameFromString(dateInString: String, timezone: String) -> String {
        guard let dateFromString = dateInString.toDate(timezone: timezone) else {
            return "No day"
        }
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
        let splittedWeatherLocation = weatherLocationObject.lattLong.split(separator: ",")
        let latt = (splittedWeatherLocation[0] as NSString).doubleValue
        let long = (splittedWeatherLocation[1] as NSString).doubleValue
//        let center = CLLocationCoordinate2D(latitude: latt, longitude: long)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: latt, longitudinalMeters: long)
        
        let initialLocation = CLLocation(latitude: latt, longitude: long)
        
        return initialLocation
    }
    
 
}

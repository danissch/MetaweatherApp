//
//  WeatherPronosticBarView.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 19/06/21.
//

import Foundation
import UIKit
import Kingfisher

class WeatherPronosticBarView: UIView {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDayLabel: UILabel!
    @IBOutlet weak var weatherButtonForAction: UIButton!
    
    var weatherImageViewUrl: String?
    var weatherDayLabelString: String?
    var weatherAction:(() -> Void)?
    var isSelected: Bool = false
    var locationDetailViewModel: LocationDetailViewModelProtocol?
    var currentWeather: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setWeatherData(weather: WeatherModel, locationDetailViewModel: LocationDetailViewModelProtocol, iconUrl: String, dayString: String, action: @escaping (() -> Void) ){
        self.locationDetailViewModel = locationDetailViewModel
        self.currentWeather = weather
        self.weatherImageViewUrl = iconUrl
        self.weatherDayLabelString = dayString
        self.weatherAction = action
        
        setWeatherIcon()
        setWeatherDayLabel()
        setWeatherButtonForAction()
        
        setSelectedViewBehavior()
    }
    
    func setWeatherIcon(){
        let weatherImageView = UIImageView()
        self.weatherImageView = weatherImageView
        self.weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.weatherImageView)
        
        //center image
        let centerXConst = NSLayoutConstraint(item: weatherImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConst = NSLayoutConstraint(item: weatherImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -7)
        let heightConstraint = NSLayoutConstraint(item: weatherImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        let widthConstraint = NSLayoutConstraint(item: weatherImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        weatherImageView.addConstraints([heightConstraint, widthConstraint])
        NSLayoutConstraint.activate([centerXConst, centerYConst])
        
        self.weatherImageView.kf.setImage(with: weatherImageViewUrl?.getImageUrlFromString())

    }
    
    func setWeatherDayLabel(){
        let weatherDayLabel = UILabel()
        self.weatherDayLabel = weatherDayLabel
        self.weatherDayLabel.text = self.weatherDayLabelString
        self.weatherDayLabel.font = UIFont(name: "Helvetica", size: 8)
        self.weatherDayLabel.textAlignment = .center
        self.weatherDayLabel.lineBreakMode = .byWordWrapping
        self.weatherDayLabel.numberOfLines = 2
        
        self.weatherDayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.weatherDayLabel)
        let centerXConst = NSLayoutConstraint(item: weatherDayLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerYConst = NSLayoutConstraint(item: weatherDayLabel, attribute: .top, relatedBy: .equal, toItem: weatherImageView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: weatherDayLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.bounds.width - 15)
        let heightConstraint = NSLayoutConstraint(item: weatherDayLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 18)
        weatherDayLabel.addConstraints([heightConstraint, widthConstraint])
        NSLayoutConstraint.activate([centerXConst, centerYConst])
    }
    
    func setWeatherButtonForAction(){
        let weatherButtonForAction = UIButton(frame: self.frame)
        self.weatherButtonForAction = weatherButtonForAction
        self.weatherButtonForAction.addTarget(self, action: #selector(actionWeatherButtonAction), for: .touchUpInside)
        self.addSubview(self.weatherButtonForAction)
        
    }
    
    func setSelectedViewBehavior(){
        if locationDetailViewModel?.selectedWeather[0] == currentWeather?.id {
            isSelected = true
        }
        
        if isSelected {
            self.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
            self.weatherDayLabel.textColor = .black
        } else {
            self.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
            self.weatherDayLabel.textColor = .white
        }
        
    }
    
    @IBAction func actionWeatherButtonAction(_ sender: Any) {
        weatherAction?()
        setSelectedViewBehavior()
        
    }
    
}

//
//  SelectedWeatherDetailsTableViewCell.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 20/06/21.
//

import Foundation
import UIKit

class SelectedWeatherDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var weather_state_nameValueLabel: UILabel!
    @IBOutlet weak var wind_direction_compassValueLabel: UILabel!
    @IBOutlet weak var createdValueLabel: UILabel!
    @IBOutlet weak var applicable_dateValueLabel: UILabel!
    @IBOutlet weak var the_tempValueLabel: UILabel!
    @IBOutlet weak var min_tempValueLabel: UILabel!
    @IBOutlet weak var max_tempValueLabel: UILabel!
    @IBOutlet weak var wind_speedValueLabel: UILabel!
    @IBOutlet weak var wind_directionValueLabel: UILabel!
    @IBOutlet weak var air_pressureValueLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var visibilityValueLabel: UILabel!
    @IBOutlet weak var predictabilityValueLabel: UILabel!
    
    var weather: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("SelectedWeatherDetailsTableViewCell awakeFromNib")
    }
    
    func setDataValuesFromModel(weather: WeatherModel){
        self.weather = weather
        setValuesToLabels()
    }
    
    func setValuesToLabels(){
        idValueLabel.text = self.weather?.id.description
        weather_state_nameValueLabel.text = self.weather?.weatherStateName.description
        wind_direction_compassValueLabel.text = self.weather?.windDirectionCompass.description
        createdValueLabel.text = self.weather?.created.description
        applicable_dateValueLabel.text = self.weather?.applicableDate.description
        the_tempValueLabel.text = self.weather?.theTemp?.description
        min_tempValueLabel.text = self.weather?.minTemp?.description
        max_tempValueLabel.text = self.weather?.maxTemp?.description
        wind_speedValueLabel.text = self.weather?.windSpeed?.description
        wind_directionValueLabel.text = self.weather?.windDirection.description
        air_pressureValueLabel.text = self.weather?.airPressure?.description
        humidityValueLabel.text = self.weather?.humidity?.description
        visibilityValueLabel.text = self.weather?.visibility?.description
        predictabilityValueLabel.text = self.weather?.predictability.description
    }
    
    
}

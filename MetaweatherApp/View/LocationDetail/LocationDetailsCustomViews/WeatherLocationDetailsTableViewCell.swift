//
//  WeatherLocationDetailsTableViewCell.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 20/06/21.
//

import Foundation
import UIKit

class WeatherLocationDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var woeidValueLabel: UILabel!
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var location_typeValueLabel: UILabel!
    @IBOutlet weak var latt_longValueLabel: UILabel!
    @IBOutlet weak var timezoneValueLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var sun_riseValueLabel: UILabel!
    @IBOutlet weak var sun_setValueLabel: UILabel!
    @IBOutlet weak var timezone_nameValueLabel: UILabel!
    
    var weatherLocationModel: WeatherLocationModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("WeatherLocationDetailsTableViewCell awakeFromNib")
    }
    
    func setValuesToWeatherDetails(weatherLocationModel: WeatherLocationModel){
        self.weatherLocationModel = weatherLocationModel
        setValuesToLabels()
    }
    
    func setValuesToLabels(){
        woeidValueLabel.text = self.weatherLocationModel?.woeid.description
        titleValueLabel.text = self.weatherLocationModel?.title
        location_typeValueLabel.text = self.weatherLocationModel?.locationType
        latt_longValueLabel.text = self.weatherLocationModel?.lattLong
        timezoneValueLabel.text = self.weatherLocationModel?.timezone
        timeValueLabel.text = self.weatherLocationModel?.time
        sun_riseValueLabel.text = self.weatherLocationModel?.sunRise
        sun_setValueLabel.text = self.weatherLocationModel?.sunSet
        timezone_nameValueLabel.text = self.weatherLocationModel?.timezoneName
    }
    
    
}

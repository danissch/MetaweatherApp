//
//  MetaweatherListTableViewCell.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation
import UIKit

class MetaweatherListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelLocationTitle: UILabel!
    @IBOutlet weak var labelLocationType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCellData(locationSearchModel: LocationSearchModel){
        self.labelLocationTitle.text = locationSearchModel.title
        self.labelLocationType.text = locationSearchModel.locationType
    }
    
    
}

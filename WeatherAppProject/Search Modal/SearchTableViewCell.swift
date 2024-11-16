//
//  SearchTableViewCell.swift
//  WeatherAppProject
//
//  Created by mac on 4/15/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var cityNameInSearchLabel: UILabel!
    
}

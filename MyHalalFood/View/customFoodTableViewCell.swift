//
//  customFoodTableViewCell.swift
//  MyHalalFood
//
//  Created by Febria Roosita Dwi on 8/7/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit

class customFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodAddressLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

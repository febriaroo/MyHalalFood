//
//  myCustomTableViewCell.swift
//  MyHalalFood
//
//  Created by Febria Roosita Dwi on 8/5/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit

class myCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var nameTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

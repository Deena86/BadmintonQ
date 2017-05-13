//
//  CustomTableviewcell.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 12/20/15.
//  Copyright © 2015 Deena. All rights reserved.
//

import UIKit

class CustomTableviewcell: UITableViewCell {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

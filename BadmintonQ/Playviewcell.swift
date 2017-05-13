//
//  Playviewcell.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 3/23/16.
//  Copyright © 2016 Deena. All rights reserved.
//

import UIKit

class Playviewcell: UITableViewCell {
    
   
    @IBOutlet weak var txtBScore1: UITextField!
    @IBOutlet weak var txtAScore1: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  BookContentTableViewCell.swift
//  RenovaLivrosUFRGS
//
//  Created by Matheus Cavalca on 6/17/15.
//  Copyright (c) 2015 Matheus Cavalca. All rights reserved.
//

import UIKit

class BookContentTableViewCell: UITableViewCell {

    @IBOutlet var lblBookName: UILabel!
    @IBOutlet var lblExpirationDate: UILabel!
    @IBOutlet var lblBuilding: UILabel!
    @IBOutlet var imgFlagSituation: UIImageView!
    @IBOutlet var lblPenalty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

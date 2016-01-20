//
//  BadgeTableViewCell.swift
//  VidCoach2
//
//  Created by Erick Custodio on 1/18/16.
//  Copyright © 2016 Erick Custodio. All rights reserved.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeInfo: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

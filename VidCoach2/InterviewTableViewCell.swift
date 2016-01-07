//
//  InterviewTableViewCell.swift
//  VidCoach2
//
//  This class handles the custom layout of each cell for the interivew list.
//
//  Created by Erick Custodio on 12/28/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit

class InterviewTableViewCell: UITableViewCell {

    //MARK: Properties
    //TODO: Add properties and outlets for awards and tracking
    @IBOutlet weak var interviewNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

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
    @IBOutlet weak var interviewNameLabel: UILabel!
    @IBOutlet weak var interviewProgress: UILabel!
    
    //These badges for testing
    @IBOutlet weak var yellowBadge: UIImageView!
    @IBOutlet weak var purpleBadge: UIImageView!
    @IBOutlet weak var greenBadge: UIImageView!
    @IBOutlet weak var redBadge: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Initially Hide Badges
        yellowBadge.hidden = true
        purpleBadge.hidden = true
        greenBadge.hidden = true
        redBadge.hidden = true


    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

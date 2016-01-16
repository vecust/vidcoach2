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
    @IBOutlet weak var viewProgress: UILabel!
    @IBOutlet weak var practiceProgress: UILabel!
    
    //These badges for testing
    @IBOutlet weak var fireBadge: UIImageView!
    @IBOutlet weak var tvBadge: UIImageView!
    @IBOutlet weak var finishBadge: UIImageView!
    @IBOutlet weak var cameraBadge: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Nice to have: circle image behind label.
        // interviewProgress.backgroundColor = UIColor(patternImage: UIImage(named: "circle")!)
        
        //Initially Hide Badges
//        yellowBadge.hidden = true
//        purpleBadge.hidden = true
//        greenBadge.hidden = true
//        redBadge.hidden = true


    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  QuestionTableViewCell.swift
//  VidCoach2
//
//  Created by Erick Custodio on 12/29/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var questionNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

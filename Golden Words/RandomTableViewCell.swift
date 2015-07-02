//
//  RandomTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-30.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class RandomTableViewCell: UITableViewCell {

    @IBOutlet weak var randomHeadlineLabel: UILabel!
    @IBOutlet weak var randomAuthorLabel: UILabel!
    @IBOutlet weak var randomPublishDateLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

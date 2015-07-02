//
//  CurrentIssueFrontCoverTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-28.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class CurrentIssueFrontCoverTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentIssueFrontCoverImageView: UIImageView!
    @IBOutlet weak var currentIssueFrontCoverHeadlineLabel: UILabel!
    @IBOutlet weak var currentIssueFrontCoverAuthorLabel: UILabel!
    @IBOutlet weak var currentIssueFrontCoverPublishDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
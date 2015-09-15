//
//  VideoTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoHeadlineLabel: UILabel!
    @IBOutlet weak var videoAuthorLabel: UILabel!
    @IBOutlet weak var videoPublishDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

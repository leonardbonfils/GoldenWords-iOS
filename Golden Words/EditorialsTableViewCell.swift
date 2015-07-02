//
//  EditorialsTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-26.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class EditorialsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var editorialHeadlineLabel: UILabel!
    @IBOutlet weak var editorialAuthorLabel: UILabel!
    @IBOutlet weak var editorialPublishDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

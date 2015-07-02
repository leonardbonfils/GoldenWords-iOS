//
//  CurrentIssueArticlesTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-28.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class CurrentIssueArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentIssueArticlesHeadlineLabel: UILabel!
    @IBOutlet weak var currentIssueArticlesAuthorLabel: UILabel!
    @IBOutlet weak var currentIssueArticlesPublishDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
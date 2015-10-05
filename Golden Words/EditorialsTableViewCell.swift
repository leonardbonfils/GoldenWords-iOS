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
    @IBOutlet weak var editorialVolumeAndIssueLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // We are adding the labels as subviews of the cell so we can access them directly as properties
    func addSubviews(view: UIView) {
        addSubview(editorialHeadlineLabel)
        addSubview(editorialAuthorLabel)
        addSubview(editorialPublishDateLabel)
        addSubview(editorialVolumeAndIssueLabel)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
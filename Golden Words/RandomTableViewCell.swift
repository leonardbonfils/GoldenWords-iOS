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
//    @IBOutlet weak var randomVolumeAndIssueLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    // Adding labels as subviews of the cell so we can access them directly as properties
    func addSubviews(view: UIView) {
        addSubview(randomHeadlineLabel)
        addSubview(randomAuthorLabel)
        addSubview(randomPublishDateLabel)
//        addSubview(randomVolumeAndIssueLabel)
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
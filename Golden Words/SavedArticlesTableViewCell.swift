//
//  SavedArticlesTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-19.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class SavedArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var savedArticlesHeadlineLabel: UILabel!
    @IBOutlet weak var savedArticlesAuthorLabel: UILabel!
    @IBOutlet weak var savedArticlesPublishDateLabel: UILabel!
    
    
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        /*        fatalError("init(coder:) could not be initialized") */
    }
    
    
    /* We are adding the labels as subviews of the cell so we can access them directly as properties */
    func addSubviews(view: UIView) {
        addSubview(savedArticlesHeadlineLabel)
        addSubview(savedArticlesAuthorLabel)
        addSubview(savedArticlesPublishDateLabel)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        /* Configure the view for the selected state */
    }

    

}

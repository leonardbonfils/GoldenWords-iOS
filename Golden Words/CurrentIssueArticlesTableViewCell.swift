//
//  CurrentIssueArticlesTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-28.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class CurrentIssueArticlesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentIssueArticlesHeadlineLabel: UILabel!
    @IBOutlet weak var currentIssueArticlesAuthorLabel: UILabel!
//    @IBOutlet weak var currentIssueArticlesPublishDateLabel: UILabel!
    var request: Alamofire.Request?
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        /*        fatalError("init(coder:) could not be initialized") */
    }
    
    func addSubviews(view: UIView) {
        addSubview(currentIssueArticlesHeadlineLabel)
        addSubview(currentIssueArticlesAuthorLabel)
//        addSubview(currentIssueArticlesPublishDateLabel)
//        addSubview(currentIssueArticlesBackgroundImageView)
        
//        bringSubviewToFront(currentIssueArticlesBackgroundImageView)
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
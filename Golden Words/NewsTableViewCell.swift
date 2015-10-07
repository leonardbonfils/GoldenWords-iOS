//
//  NewsTable.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var newsHeadlineLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsPublishDateLabel: UILabel!
    @IBOutlet weak var newsVolumeAndIssueLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews(view: UIView) {
        addSubview(newsHeadlineLabel)
        addSubview(newsAuthorLabel)
        addSubview(newsPublishDateLabel)
        addSubview(newsVolumeAndIssueLabel)
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

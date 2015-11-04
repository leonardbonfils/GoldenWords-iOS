//
//  VideoTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbnailImage: UIImageView!
    @IBOutlet weak var videoHeadlineLabel: UILabel!
    @IBOutlet weak var videoPublishDateLabel: UILabel!
    
    var request: Alamofire.Request?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addSubviews(view: UIView) {
        addSubview(videoThumbnailImage)
        addSubview(videoHeadlineLabel)
        addSubview(videoPublishDateLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
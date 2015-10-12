//
//  VideoTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var videoHeadline: UILabel!
    @IBOutlet weak var videoPublishDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addSubviews(view: UIView) {
        addSubview(videoThumbnail)
        addSubview(videoHeadline)
        addSubview(videoPublishDate)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

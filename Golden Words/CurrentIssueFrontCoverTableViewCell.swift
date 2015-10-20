//
//  CurrentIssueFrontCoverTableViewCell.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-28.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class CurrentIssueFrontCoverTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentIssueFrontCoverImageView: UIImageView!
    var request: Alamofire.Request?
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    

    func addSubviews(view: UIView) {
        addSubview(currentIssueFrontCoverImageView)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
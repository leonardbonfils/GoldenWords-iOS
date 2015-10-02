//
//  PhotoBrowserCollectionViewCell.swift
//  
//
//  Created by Léonard Bonfils on 2015-09-21.
//
//

import UIKit
import Alamofire

class PhotoBrowserCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    var request: Alamofire.Request?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        imageView.frame = bounds
        addSubview(imageView)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
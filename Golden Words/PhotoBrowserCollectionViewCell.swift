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
    
//    @IBOutlet var imageView: UIImageView!
    var request: Alamofire.Request?
    
    var imageView: UIImageView!
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(imageView)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit}

//    required init?(coder aDecoder: NSCoder!) {
//        super.init(coder: aDecoder)
////        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        backgroundColor = UIColor(white: 0.1, alpha: 1.0)
//
//        let imageViewFrame = CGRectMake(0, 0, self.frame.width, self.frame.size.height)
//        imageView.frame = imageViewFrame
//        addSubview(imageView)
//
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
}
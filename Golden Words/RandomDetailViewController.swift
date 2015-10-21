//
//  RandomDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-30.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class RandomDetailViewController: UIViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    @IBOutlet weak var randomDetailNavigationItem: UINavigationItem!
    
    @IBOutlet weak var randomDetailWebView: UIWebView!
    
    var randomArticleTitleThroughSegue: String?
    var randomArticleAuthorThroughSegue: String?
    var randomArticlePublishDateThroughSegue: String?
    var randomArticleVolumeIndexThroughSegue: String?
    var randomArticleIssueIndexThroughSegue: String?
    var randomArticleArticleContentThroughSegue: String?

    @IBOutlet weak var randomArticleDetailHeadlineLabel: UILabel!
    @IBOutlet weak var randomArticleDetailAuthorLabel: UILabel!
    @IBOutlet weak var randomArticleDetailPublishDateLabel: UILabel!
    @IBOutlet weak var randomArticleDetailVolumeAndIssueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inserting the selected random article's title
        randomDetailNavigationItem.title = "Article"
        
        // Swipe recognizers for left and right edges (can be used later).
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        // Setting the right values for all labels, from values given through the segue
        randomArticleDetailHeadlineLabel.text = randomArticleTitleThroughSegue
        randomArticleDetailAuthorLabel.text = randomArticleAuthorThroughSegue
        randomArticleDetailPublishDateLabel.text = randomArticlePublishDateThroughSegue
        randomArticleDetailVolumeAndIssueLabel.text = "Volume \(randomArticleVolumeIndexThroughSegue!) - Issue \(randomArticleIssueIndexThroughSegue!)"
        
//        // Version 1.1 feature - 3D Touch Link Preview
//        randomDetailWebView.allowsLinkPreview = true
        
        randomDetailWebView.loadHTMLString(randomArticleArticleContentThroughSegue!, baseURL: nil)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .Left) {
            print("Swipe left")
            
        }
        
        if (sender.direction == .Right) {
            print("Swipe right")
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
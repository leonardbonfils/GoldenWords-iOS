    //
//  NewsDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-29.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    @IBOutlet weak var newsDetailNavigationItem: UINavigationItem!
    
    @IBOutlet weak var newsDetailWebView: UIWebView!
    
    var newsArticleTitleThroughSegue: String?
    var newsArticleAuthorThroughSegue: String?
    var newsArticlePublishDateThroughSegue: String?
    var newsArticleVolumeIndexThroughSegue: String?
    var newsArticleIssueIndexThroughSegue: String?
    var newsArticleArticleContentThroughSegue: String?
    

    @IBOutlet weak var newsArticleDetailHeadlineLabel: UILabel!
    @IBOutlet weak var newsArticleDetailAuthorLabel: UILabel!
    @IBOutlet weak var newsArticleDetailPublishDateLabel: UILabel!
    @IBOutlet weak var newsArticleDetailVolumeAndIssueLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inserting the selected news article's title
        newsDetailNavigationItem.title = newsArticleTitleThroughSegue
        
        // Swipe recognizers for left and right edges (can be used later).
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        // Setting the right values for all labels, from values given through the segue
        newsArticleDetailHeadlineLabel.text = newsArticleTitleThroughSegue
        newsArticleDetailAuthorLabel.text = newsArticleAuthorThroughSegue
        newsArticleDetailPublishDateLabel.text = newsArticlePublishDateThroughSegue
        newsArticleDetailVolumeAndIssueLabel.text = "Volume \(newsArticleVolumeIndexThroughSegue) - Issue \(newsArticleIssueIndexThroughSegue) "
        
//        // Version 1.1 feature - 3D Touch Link Preview
//        newsDetailWebView.allowsLinkPreview = true
        
        newsDetailWebView.loadHTMLString(newsArticleArticleContentThroughSegue!, baseURL: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleSwipes (sender: UISwipeGestureRecognizer) {
        
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

    //
//  NewsDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-29.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
        
    @IBOutlet weak var newsDetailNavigationItem: UINavigationItem!
    
    @IBOutlet weak var newsDetailWebView: UIWebView!
    
    var newsArticleTitleThroughSegue: String?
    var newsArticleAuthorThroughSegue: String?
//    var newsArticlePublishDateThroughSegue: String?
    var newsArticleVolumeIndexThroughSegue: String?
    var newsArticleIssueIndexThroughSegue: String?
    var newsArticleArticleContentThroughSegue: String?
    

    @IBOutlet weak var newsArticleDetailHeadlineLabel: UILabel!
    @IBOutlet weak var newsArticleDetailAuthorLabel: UILabel!
//    @IBOutlet weak var newsArticleDetailPublishDateLabel: UILabel!
    @IBOutlet weak var newsArticleDetailVolumeAndIssueLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inserting the selected news article's title
        newsDetailNavigationItem.title = "Article"
        
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
//        newsArticleDetailPublishDateLabel.text = newsArticlePublishDateThroughSegue
        newsArticleDetailVolumeAndIssueLabel.text = "V.\(newsArticleVolumeIndexThroughSegue!) - Issue \(newsArticleIssueIndexThroughSegue!) "
        
        // Allowing webView link previews
        if #available(iOS 9.0, *) {
            newsDetailWebView.allowsLinkPreview = true
        } else {
            // Fallback on earlier versions
        }
        
        newsDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        newsDetailWebView.loadHTMLString(newsArticleArticleContentThroughSegue!, baseURL: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 9.0, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let saveArticleAction = UIPreviewAction(title: "Save Article", style: .Default) { (action, viewController) -> Void in
            /* Save the article to the device's storage permanently */
            print("You saved Article \(self.newsArticleArticleContentThroughSegue)")
        }
        
        return [saveArticleAction]
        
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

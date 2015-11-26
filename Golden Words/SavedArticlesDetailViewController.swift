//
//  SavedArticlesDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-19.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class SavedArticlesDetailViewController: UIViewController {
    
    @IBOutlet weak var savedArticleDetailNavigationItem: UINavigationItem!
    
    @IBOutlet weak var savedArticleDetailWebView: UIWebView!
    
    var savedArticleTitleThroughSegue: String?
    var savedArticleAuthorThroughSegue: String?
    var savedArticleVolumeIndexThroughSegue: String?
    var savedArticleIssueIndexThroughSegue: String?
    var savedArticleArticleContentThroughSegue: String?
    
    @IBOutlet weak var savedArticleDetailHeadlineLabel: UILabel!
    @IBOutlet weak var savedArticleDetailAuthorLabel: UILabel!
    @IBOutlet weak var savedArticleVolumeAndIssueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedArticleDetailNavigationItem.title = "Article"
        
        /* Swipe recognizers for left and right edges (can be used later). */
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        savedArticleDetailHeadlineLabel.text = savedArticleTitleThroughSegue
        savedArticleDetailAuthorLabel.text = savedArticleAuthorThroughSegue
        savedArticleVolumeAndIssueLabel.text = "V.\(savedArticleVolumeIndexThroughSegue) - Issue \(savedArticleIssueIndexThroughSegue)"
        
        // Allowing webView link previews
        savedArticleDetailWebView.allowsLinkPreview = true
        
        savedArticleDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        savedArticleDetailWebView.loadHTMLString(savedArticleArticleContentThroughSegue!, baseURL: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let deleteFromSavedArticles = UIPreviewAction(title: "Delete from Saved Articles", style: .Destructive) { (action, viewController) -> Void in
            print("You delete Article \(self.savedArticleTitleThroughSegue)")
        }
        
        return [deleteFromSavedArticles]
        
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

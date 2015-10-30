//
//  CurrentIssueDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-28.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class CurrentIssueDetailViewController: UIViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    @IBOutlet weak var currentIssueNavigationItem: UINavigationItem!
    
    @IBOutlet weak var currentIssueDetailWebView: UIWebView!

    var currentIssueArticleTitleThroughSegue: String?
    var currentIssueAuthorThroughSegue: String?
    var currentIssuePublishDateThroughSegue: String?
    var currentIssueArticleContentThroughSegue: String?

    @IBOutlet weak var currentIssueDetailHeadlineLabel: UILabel!
    @IBOutlet weak var currentIssueDetailAuthorLabel: UILabel!
    @IBOutlet weak var currentIssueDetailPublishDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inserting the selected currentIssue's title
        currentIssueNavigationItem.title = "Article"
        
        // "Swipe from left edge" recognizer
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        currentIssueDetailHeadlineLabel.text = currentIssueArticleTitleThroughSegue
        currentIssueDetailAuthorLabel.text! = currentIssueAuthorThroughSegue!
        currentIssueDetailPublishDateLabel.text = currentIssuePublishDateThroughSegue
        
        /*
        
        Version 1.1 feature - 3D Touch Link Preview
        editorialDetailWebView.allowsLinkPreview = true
        
        */
        
        currentIssueDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        currentIssueDetailWebView.loadHTMLString(currentIssueArticleContentThroughSegue!, baseURL: nil)
        
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
            print("You saved Article \(self.currentIssueArticleContentThroughSegue)")
            }
        
        return [saveArticleAction]
        
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

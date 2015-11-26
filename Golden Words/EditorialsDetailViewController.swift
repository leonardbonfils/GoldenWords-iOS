//
//  EditorialsDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-26.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class EditorialsDetailViewController: UIViewController {
    
    @IBOutlet weak var editorialDetailNavigationItem: UINavigationItem!

    @IBOutlet weak var editorialDetailWebView: UIWebView!
    
    var editorialTitleThroughSegue: String?
    var editorialAuthorThroughSegue: String?
//    var editorialPublishDateThroughSegue: String?
    var editorialVolumeIndexThroughSegue: String?
    var editorialIssueIndexThroughSegue: String?
    var editorialArticleContentThroughSegue: String?

    @IBOutlet weak var editorialDetailHeadlineLabel: UILabel!
    @IBOutlet weak var editorialDetailAuthorLabel: UILabel!
//    @IBOutlet weak var editorialDetailPublishDateLabel: UILabel!
    @IBOutlet weak var editorialDetailVolumeAndIssueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorialDetailNavigationItem.title = "Article"
        
        /* Swipe recognizers for left and right edges (can be used later). */
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        editorialDetailHeadlineLabel.text = editorialTitleThroughSegue
        editorialDetailAuthorLabel.text = editorialAuthorThroughSegue
        editorialDetailVolumeAndIssueLabel.text = "V.\(editorialVolumeIndexThroughSegue!) - Issue \(editorialIssueIndexThroughSegue!)"
        
        // Allowing webView link previews
        editorialDetailWebView.allowsLinkPreview = true
        
        /*
        let justifiedArticleContent = "<p style=\"text-align:justify\"> \(editorialArticleContentThroughSegue) </p>"
        */
        
        editorialDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        editorialDetailWebView.loadHTMLString(editorialArticleContentThroughSegue!, baseURL: nil)
        
        

    }
/*
    func webViewDidFinishLoad(webView: UIWebView!) {
        
        var webViewFrame: CGRect = editorialDetailWebView.frame
        webViewFrame.size.height = 1
        editorialDetailWebView.frame = webViewFrame
        var fittingSize: CGSize = (editorialDetailWebView.sizeThatFits(CGSizeZero))
        webViewFrame.size = fittingSize
        
        editorialDetailWebView.frame = webViewFrame
        
        var webViewHeight = editorialDetailWebView.frame.size.height

    }
*/


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let saveArticleAction = UIPreviewAction(title: "Save Article", style: .Default) { (action, viewController) -> Void in
            /* Save the article to the device's storage permanently */
            print("You saved Article \(self.editorialTitleThroughSegue)")
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

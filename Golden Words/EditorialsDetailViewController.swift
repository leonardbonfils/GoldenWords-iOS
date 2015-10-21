//
//  EditorialsDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-26.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class EditorialsDetailViewController: UIViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    @IBOutlet weak var editorialDetailNavigationItem: UINavigationItem!

    @IBOutlet weak var editorialDetailWebView: UIWebView!
    
    @IBOutlet weak var editorialDetailScrollView: UIScrollView!
    
    var editorialTitleThroughSegue: String?
    var editorialAuthorThroughSegue: String?
    var editorialPublishDateThroughSegue: String?
    var editorialVolumeIndexThroughSegue: String?
    var editorialIssueIndexThroughSegue: String?
    var editorialArticleContentThroughSegue: String?

    @IBOutlet weak var editorialDetailHeadlineLabel: UILabel!
    @IBOutlet weak var editorialDetailAuthorLabel: UILabel!
    @IBOutlet weak var editorialDetailPublishDateLabel: UILabel!
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
        editorialDetailPublishDateLabel.text = editorialPublishDateThroughSegue
        editorialDetailVolumeAndIssueLabel.text = "Volume \(editorialVolumeIndexThroughSegue) - Issue \(editorialIssueIndexThroughSegue)"
        
        

        /*
        
        Version 1.1 feature - 3D Touch Link Preview
        editorialDetailWebView.allowsLinkPreview = true

        */
        
        /*
        let justifiedArticleContent = "<p style=\"text-align:justify\"> \(editorialArticleContentThroughSegue) </p>"
        */
        
        self.editorialDetailWebView.loadHTMLString(editorialArticleContentThroughSegue!, baseURL: nil)
        
        self.editorialDetailScrollView.addSubview(editorialDetailWebView)
        self.editorialDetailScrollView.addSubview(editorialDetailHeadlineLabel)
        self.editorialDetailScrollView.addSubview(editorialDetailAuthorLabel)
        self.editorialDetailScrollView.addSubview(editorialDetailPublishDateLabel)
        self.editorialDetailScrollView.addSubview(editorialDetailVolumeAndIssueLabel)
        
        self.editorialDetailScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.editorialDetailWebView.scrollView.frame.height)
        
/*        editorialDetailWebView.sizeToFit()
*/
        

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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        editorialDetailScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * 2.0)
        
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

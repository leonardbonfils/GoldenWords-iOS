//
//  AboutViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    var aboutGoldenWordsSummary = "Golden Words, founded in 1967, is a non-profit satirical newspaper published by the Engineering Society of Queen’s University. It addresses relevant campus issues whenever applicable with a humorous perspective. We work with volunteers of students from all faculties to produce 26 issues per annual volume. The opinions expressed herein are not necessarily those of the Queen's Engineering Society or of its members. Unless otherwise stated, all submitted material is the property of Golden Words and is reviewed by the editors in accordance with the 2014 editorial policy, which is availiable upon request. The editors reserve the right to make final editing decisions. Any informal complaints or issues regarding the content of the paper should be forwarded to the editors (see below). Any formal complaints or issues should be forwarded to the chair of the Engineering Society Board of Directors (see below)."

    @IBOutlet weak var aboutGoldenWordsLabel: UILabel!
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        aboutScrollView = UIScrollView(frame: view.bounds)
//        aboutScrollView.contentSize = CGSize(width: self.aboutGoldenWordsLabel.bounds.size.width, height: self.aboutGoldenWordsLabel.bounds.size.height * 2.0)
//        view.addSubview(aboutScrollView)
//        
//        let edsEmail = "eds@goldenwords.net"
//        let edsURL = NSURL(string: "mailto:\(edsEmail)")
//        
//        let boardEmail = "board@engsoc.queensu.ca"
//        let boardURL = NSURL(string: "mailto:\(boardEmail)")
        
        aboutGoldenWordsLabel.text = aboutGoldenWordsSummary
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        // Do any additional setup after loading the view.
    }
    
//    @IBAction func openInformalComplaintsEmail(sender: AnyObject) {
//        
//        var emailTitle = "Complaint regarding Golden Words content"
//        var messageBody = ""
//        var toRecipients = ["eds@goldenwords.net"]
//        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
//        mailCompose.mailComposeDelegate = self
//        mailCompose.setSubject(emailTitle)
//        mailCompose.setMessageBody(messageBody, isHTML: false)
//        mailCompose.setToRecipients(toRecipients)
//        
//        self.presentViewController(mailCompose, animated: true, completion: nil)
//        
//    }
//    
//    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error: NSError?) {
//        switch result.rawValue {
//        case MFMailComposeResultCancelled.rawValue:
//            print("Mail cancelled")
//        case MFMailComposeResultSaved.rawValue:
//            print("Mail saved")
//        case MFMailComposeResultSent.rawValue:
//            print("Mail sent")
//        case MFMailComposeResultFailed.rawValue:
//            print("Mail sent failure: %@", [error!.localizedDescription])
//        default:
//            break
//        }
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//    }
//    
//    
//    @IBAction func openFormalComplaintsEmail(sender: AnyObject) {
//        
//        var emailTitle = "Complaint regarding Golden Words content"
//        var messageBody = ""
//        var toRecipients = ["board@engsoc.queensu.ca"]
//        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
//        mailCompose.mailComposeDelegate = self
//        mailCompose.setSubject(emailTitle)
//        mailCompose.setMessageBody(messageBody, isHTML: false)
//        mailCompose.setToRecipients(toRecipients)
//        
//        self.presentViewController(mailCompose, animated: true, completion: nil)
//
//        
//        
//        
//        
//        
//    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

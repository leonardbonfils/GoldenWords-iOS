//
//  ContactUsViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = goldenWordsYellow
        
        // Configuring the revealViewcontroller
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        /* initializing all email addresses used to be contacted by users */
        
        let editorsEmailAddress = "eds@goldenwords.net"
        let businessManagerEmailAddress = "biz@goldenwords.net"
        let developerEmailAddress = "appledevelopment@goldenwords.net"
        let operationsManagerEmailAddress = "ops@goldenwords.net"
        
        /* Initializing the URLs corresponding to each email address */
        let editorsURL = NSURL(string: "mailto:\(editorsEmailAddress)")
        let businessManagerURL = NSURL(string: "mailto:\(businessManagerEmailAddress)")
        let developerURL = NSURL(string: "mailto:\(developerEmailAddress)")
        let operationsManagerURL = NSURL(string: "mailto:\(operationsManagerEmailAddress)")
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func editorsContactButton(sender: UIButton) {
        var emailTitle = "GW feedback"
        var messageBody = ""
        var toRecipients = ["eds@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    @IBAction func businessManagerContactButton(sender: UIButton) {
        var emailTitle = "GW feedback"
        var messageBody = ""
        var toRecipients = ["biz@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    
    @IBAction func developerContactButton(sender: UIButton) {
        var emailTitle = "GW iPhone app feedback"
        var messageBody = ""
        var toRecipients = ["appledevelopment@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    @IBAction func operationsManagerContactButton(sender: UIButton) {
        var emailTitle = "GW feedback"
        var messageBody = ""
        var toRecipients = ["ops@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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

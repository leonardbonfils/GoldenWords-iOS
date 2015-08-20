//
//  CurrentIssueTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

@IBDesignable

class CurrentIssueTableViewController: UITableViewController {
    
    var currentIssueFrontCoverImages = [String]()
    var currentIssueFrontCoverHeadline = [String]()
    var currentIssueFrontCoverAuthor = [String]()
    var currentIssueFrontCoverPublishDate = [String]()
    
    var currentIssueArticlesHeadline = [String]()
    var currentIssueArticlesAuthor = [String]()
    var currentIssueArticlesPublishDate = [String]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hamburger button configuration
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280

        
        
        // Static data - Front Cover
        
        currentIssueFrontCoverImages = ["Test image 1"]
        
        currentIssueFrontCoverHeadline = ["Front Cover Headline 1"]
        
        currentIssueFrontCoverAuthor = ["Front Cover Author 1"]
        
        currentIssueFrontCoverPublishDate = ["FC April 1st"]
        
        tableView.estimatedRowHeight = 50
        
        
        // Static data - Articles
        
        currentIssueArticlesHeadline = ["Headline 1",
                                        "Headline 2",
                                        "Headline 3",
                                        "Headline 4"]
        
        currentIssueArticlesAuthor = ["Author 1",
                                      "Author 2",
                                      "Author 3",
                                      "Author 4"]
        
        currentIssueArticlesPublishDate = ["May 1st",
                                           "May 2nd",
                                           "May 3rd",
                                           "May 4th"]
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return (currentIssueArticlesAuthor.count + 1) // As of 18/08/2015, this returns 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        // Populating data in the "Front Cover" type cell(s)
        if row == 0 {
            let cell:CurrentIssueFrontCoverTableViewCell = CurrentIssueFrontCoverTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CurrentIssueFrontCoverIdentifier")
            
            if let cIFC_ImageView = cell.currentIssueFrontCoverImageView {
                cIFC_ImageView.image = UIImage(named: "Test Image 1.jpg")
            }
            
            if let cIFC_HeadlineLabel = cell.currentIssueFrontCoverHeadlineLabel {
                cIFC_HeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                cIFC_HeadlineLabel.text = currentIssueFrontCoverHeadline[row]
            }
            
            if let cIFC_AuthorLabel = cell.currentIssueFrontCoverAuthorLabel {
                cIFC_AuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
                cIFC_AuthorLabel.text = currentIssueFrontCoverAuthor[row]
            }
            
            if let cIFC_PublishDateLabel = cell.currentIssueFrontCoverPublishDateLabel {
                cIFC_PublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
                cIFC_PublishDateLabel.text = currentIssueFrontCoverPublishDate[row]
            }
            
            return cell
        }
        
        // Populating data in the "Articles" type cells
        else {
            let cell:CurrentIssueArticlesTableViewCell = CurrentIssueArticlesTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CurrentIssueArticlesIdentifier")
            
            if let cIAHeadlineLabel = cell.currentIssueArticlesHeadlineLabel {
                cIAHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                cIAHeadlineLabel.text = currentIssueArticlesHeadline[row]
            }
            
            if let cIAAuthorLabel = cell.currentIssueArticlesAuthorLabel {
                cIAAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
                cIAAuthorLabel.text = currentIssueArticlesAuthor[row]
            }
            
            if let cIAPublishDateLabel = cell.currentIssueArticlesPublishDateLabel {
                cIAPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
                cIAPublishDateLabel.text = currentIssueArticlesPublishDate[row]
            }
            
            self.tableView.rowHeight = 80
            
            return cell
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowCurrentIssueArticleDetailsFromFrontCover") || (segue.identifier == "ShowCurrentIssueArticleDetailsNotFromFrontCover") {
            
            let detailViewController = segue.destinationViewController as! CurrentIssueDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath!.row
            
                if row == 0 {
            
                    detailViewController.currentIssueArticleTitleThroughSegue = currentIssueFrontCoverHeadline[row]
                
                }
            
                else {
                    
                    detailViewController.currentIssueArticleTitleThroughSegue = currentIssueArticlesHeadline[row-1]
                    
            }
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

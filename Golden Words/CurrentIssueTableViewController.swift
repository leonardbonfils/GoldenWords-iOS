//
//  CurrentIssueTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

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
        
        self.revealViewController().rearViewRevealWidth = 260

        
        
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
        
        return (currentIssueArticlesAuthor.count + 1)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        let row = indexPath.row
        
        // Populating data in the "Front Cover" type cell(s)
        
        if indexPath.row <= (currentIssueFrontCoverImages.count - 1) {
            let cell0 = tableView.dequeueReusableCellWithIdentifier("CurrentIssueFrontCoverIdentifier", forIndexPath: indexPath) as! CurrentIssueFrontCoverTableViewCell
            
            cell0.currentIssueFrontCoverImageView.image = UIImage(named: currentIssueFrontCoverImages[row])
            
            cell0.currentIssueFrontCoverHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell0.currentIssueFrontCoverHeadlineLabel.text = currentIssueFrontCoverHeadline[row]
            
            cell0.currentIssueFrontCoverAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell0.currentIssueFrontCoverAuthorLabel.text = currentIssueFrontCoverAuthor[row]
            
            cell0.currentIssueFrontCoverPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell0.currentIssueFrontCoverPublishDateLabel.text = currentIssueFrontCoverPublishDate[row]
        
            cell = cell0
            
            
        }
        
        // Populating data in the "Articles" type cells
        
        if indexPath.row > (currentIssueArticlesHeadline.count - 1) {
            let cell1 = tableView.dequeueReusableCellWithIdentifier("CurrentIssueArticlesIdentifier", forIndexPath: indexPath) as! CurrentIssueArticlesTableViewCell
            
            cell1.currentIssueArticlesHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell1.currentIssueArticlesHeadlineLabel.text = currentIssueArticlesHeadline[row]
            
            cell1.currentIssueArticlesAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell1.currentIssueArticlesAuthorLabel.text = currentIssueArticlesAuthor[row]
            
            cell1.currentIssueArticlesPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell1.currentIssueArticlesPublishDateLabel.text = currentIssueArticlesPublishDate[row]
            
            cell = cell1
            
            self.tableView.rowHeight = 80
        }
        
        return cell
        
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
            let row = myIndexPath.row
            
                if row == 0 {
            
                    detailViewController.currentIssueArticleTitleThroughSegue = currentIssueFrontCoverHeadline[row!]
                
                }
            
                else {
                    
                    detailViewController.currentIssueArticleTitleThroughSegue = currentIssueArticlesHeadline[row!-1]
                    
            }
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

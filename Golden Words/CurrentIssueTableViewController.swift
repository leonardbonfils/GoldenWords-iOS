//
//  CurrentIssueTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class CurrentIssueTableViewController: UITableViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    var currentIssueFrontCoverImages = [String]()
    var currentIssueFrontCoverHeadline = [String]()
    var currentIssueFrontCoverAuthor = [String]()
    var currentIssueFrontCoverPublishDate = [String]()
    
    var currentIssueArticlesHeadline = [String]()
    var currentIssueArticlesAuthor = [String]()
    var currentIssueArticlesPublishDate = [String]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // Refresh control variables - start
    
    // Table View outlet used for the refresh control
    @IBOutlet var currentIssueTableView: UITableView!
    
    // Declaring fake data to test the table view
//    var dataArray: [String] = ["One", "Two", "Three", "Four", "Five"]
    
    // an indicator used to know if the reveal view controller is currently shown (i.e. to know if the hamburger menu is open)
    var revealViewControllerIndicator : Int = 0
    
    // Declaring refreshControl --> I actually did not need to declare it since it is part of the UITableViewController class by default
//    var refreshControl: UIRefreshControl!
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    // Refresh control variables - end
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hamburger button configuration
        
        if self.revealViewController() != nil {
            revealViewControllerIndicator = 1
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280

        // Preliminary refresh control "set up"
        currentIssueTableView.delegate = self
        currentIssueTableView.dataSource = self
        
        // Creating and configuring the refreshControl subview
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = goldenWordsYellow
        refreshControl!.tintColor = UIColor.whiteColor()
        currentIssueTableView.addSubview(refreshControl!)
        
        loadCustomRefreshContents()
    
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
    
    // To reload the data in the table view with new data from the API, use the reloadData method
        
        
        
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
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = refreshControl!.bounds
        
        for (var i=0; i < customView.subviews.count; i++) {
            labelsArray.append(customView.viewWithTag(i+1) as! UILabel)
            
        refreshControl!.addSubview(customView)
        }
    }
    
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            // Selecting the UILabel object in the labelsArray array, and applying the animation
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
                    self.labelsArray[self.currentLabelIndex].textColor = UIColor.blackColor()
                    
                    }, completion: { (finished) -> Void in
                        ++self.currentLabelIndex
                        
                        if self.currentLabelIndex < self.labelsArray.count {
                            self.animateRefreshStep1()
                        }
                        else {
                            self.animateRefreshStep2()
                        }
                })
                
        })
        
    }

    
    func animateRefreshStep2() {
        UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[1].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[2].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[3].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[4].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[5].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[6].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[7].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[8].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[9].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[10].transform = CGAffineTransformMakeScale(1.5, 1.5)

            
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.labelsArray[0].transform = CGAffineTransformIdentity
                    self.labelsArray[1].transform = CGAffineTransformIdentity
                    self.labelsArray[2].transform = CGAffineTransformIdentity
                    self.labelsArray[3].transform = CGAffineTransformIdentity
                    self.labelsArray[4].transform = CGAffineTransformIdentity
                    self.labelsArray[5].transform = CGAffineTransformIdentity
                    self.labelsArray[6].transform = CGAffineTransformIdentity
                    self.labelsArray[7].transform = CGAffineTransformIdentity
                    self.labelsArray[8].transform = CGAffineTransformIdentity
                    self.labelsArray[9].transform = CGAffineTransformIdentity
                    self.labelsArray[10].transform = CGAffineTransformIdentity

                    
                    }, completion: { (finished) -> Void in
                        if self.refreshControl!.refreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        } else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            for var i=0; i<self.labelsArray.count; i++ {
                                self.labelsArray[i].textColor = UIColor.blackColor()
                                self.labelsArray[i].transform = CGAffineTransformIdentity
                            }
                        }
                })
        })
        
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if refreshControl!.refreshing {
            if !isAnimating {
                doSomething()
                animateRefreshStep1()
            }
        }
    }
    
    func getNextColor() -> UIColor {
        var colorsArray: [UIColor] = [goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        ++currentColorIndex
        
        return returnColor
    }
    
    func doSomething() {
        timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "endOfWork", userInfo: nil, repeats: true)
    }
    
    func endOfWork() {
        refreshControl!.endRefreshing()
        
        timer.invalidate()
        timer = nil
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
        
        if revealViewControllerIndicator == 0 {
        
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
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}


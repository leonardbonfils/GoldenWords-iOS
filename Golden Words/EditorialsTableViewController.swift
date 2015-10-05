//
//  EditorialsTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class EditorialsTableViewController: UITableViewController {

    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)

//    // Declaring data strings for labels in EditorialsTableViewController
//    
//    var editorialHeadline = [String]()
//    var editorialAuthor = [String]()
//    var editorialPublishDate = [String]()
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // Refresh control variables - start
    
    // Table View Outlet used for the refresh control
    @IBOutlet var editorialsTableView: UITableView!
    
    var editorialObjects = NSMutableArray()
    
    @IBOutlet weak var editorialsCell: EditorialsTableViewCell!
    
    var customRefreshControl = UIRefreshControl?()
    
    var revealViewControllerIndicator : Int = 0
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingEditorials = false
    var currentPage = 1
    
    let PhotoBrowserCellIdentifier = "EditorialTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    // Refresh control variables - end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hamburger button configuration
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280
        
        // Preliminary refresh control "set up"
        editorialsTableView.delegate = self
        editorialsTableView.dataSource = self
        
        // Creating and configuring the customRefreshControl subview
//        customRefreshControl = UIRefreshControl()
        customRefreshControl!.backgroundColor = goldenWordsYellow
        customRefreshControl!.tintColor = UIColor.whiteColor()
        customRefreshControl!.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        editorialsTableView.addSubview(customRefreshControl!)
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Pictures"
        
        loadCustomRefreshContents()
        
        populateEditorials()
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.customRefreshControl!.attributedTitle = NSAttributedString(string: updateString)
        
//        // Static data to test my table view controller
//        
//        editorialHeadline =  ["Article about Paris",
//                              "Article about London",
//                              "Article about New York",
//                              "Article about San Francisco"]
//        
//        editorialAuthor = ["Mark",
//                           "Alexander",
//                           "Alexandra",
//                           "Giorgio"]
//        
//        editorialPublishDate = ["September 27th",
//                                "September 28th",
//                                "September 29th",
//                                "September 30th"]
        
        tableView.estimatedRowHeight = 50
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = customRefreshControl!.bounds
        
        for (var i=0; i < customView.subviews.count; i++) {
            labelsArray.append(customView.viewWithTag(i+1) as! UILabel)
            
        customRefreshControl!.addSubview(customView)
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
                        if self.customRefreshControl!.refreshing {
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
        if customRefreshControl!.refreshing {
            if !isAnimating {
                handleRefresh()
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
    
//    func doSomething() {
//        timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "endOfWork", userInfo: nil, repeats: true)
//    }
    
    func endOfWork() {
        customRefreshControl!.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return editorialObjects.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("EditorialTableCellIdentifier", forIndexPath: indexPath) as! EditorialsTableViewCell
        
        let row = indexPath.row
//        cell.editorialHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        cell.editorialHeadlineLabel.text = editorialHeadline[row]
//        
//        cell.editorialAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.editorialAuthorLabel.text = editorialAuthor[row]
//        
//        cell.editorialPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.editorialPublishDateLabel.text = editorialPublishDate[row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EditorialTableCellIdentifier", forIndexPath: indexPath) as! EditorialsTableViewCell
        
        let title = (editorialObjects.objectAtIndex(indexPath.row) as! EditorialElement).title
        let timeStamp = (editorialObjects.objectAtIndex(indexPath.row) as! EditorialElement).timeStamp
        let imageURL = (editorialObjects.objectAtIndex(indexPath.row) as! EditorialElement).imageURL
        let author = (editorialObjects.objectAtIndex(indexPath.row) as! EditorialElement).author
        
        let issueNumber = (editorialObjects.objectAtIndex(indexPath.row) as! EditorialElement).issueNumber
        let volumeNumber = (editorialObjects.objectAtIndex(indexPath.row) as! EditorialElement).volumeNumber
        
        let articleContent = (editorialObjects.objectAtIndex(indexPath.row) as! EditorialElement).articleContent
        
        // Unlike the Pictures Collection View, there is no need to create another Alamofire request here, since we already have all the content we want from the JSON we downloaded. There is no URL that we wish to place a request with to get extra content.
        
        cell.editorialHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.editorialHeadlineLabel.text = title
        
        cell.editorialAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.editorialAuthorLabel.text = author
        
        cell.editorialPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.editorialPublishDateLabel.text = timeStamp
        
        cell.editorialVolumeAndIssueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.editorialVolumeAndIssueLabel.text = "Volume \(volumeNumber) - Issue \(issueNumber)"
        
        return cell
    }
    
    
    
    // The "didDeselectItemAtIndexPath" method from the Pictures View Controller does not need to be implemented since the Storyboard has already defined the segue from each table view cell to the detail view controller (i.e. select a cell, it takes you to the corresponding view controller).
    

    
    
    
    
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

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowEditorialDetails" {
         
            let detailViewController = segue.destinationViewController as! EditorialsDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            // Passing the article information through the segue
            detailViewController.editorialTitleThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).title
            detailViewController.editorialPublishDateThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).timeStamp
            detailViewController.editorialVolumeIndexThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            detailViewController.editorialIssueIndexThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.editorialAuthorThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.editorialArticleContentThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).articleContent
            
//            detailViewController.editorialTitleThroughSegue = editorialHeadline[row!]
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8) {
            populateEditorials()
        }
    }
    
    func populateEditorials() {
        if populatingEditorials {
            return
        }
        
        populatingEditorials = true
        
        Alamofire.request(GWNetworking.Router.Editorials(self.currentPage)).responseJSON() {
            (request, response, result) in
            
            if result.error == nil {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    
                    // Making an array of all the node IDs from the JSON file
                    let nodeIDArray : [String]
                    var nodeCounter : Int = 0
                    for nodeCounter in 0..<9 {
                        
                        if let jsonValue = result.value {
                            
                            nodeIDArray[nodeCounter] = jsonValue{nodeCounter}.string
                            let editorialInfos : EditorialElement = ((jsonValue as! NSDictionary).valueForKey("\(nodeIDArray[nodeCounter])") as! [NSDictionary]).map { EditorialElement(title: $0["title"] as! String, nodeID: $0["nid"] as! Int, timeStamp: $0["revision_timestamp"] as! Int, imageURL: $0["image_url"] as! String, author: $0["author"], issueNumber: $0["issue_int"] as! Int, volumeNumber: $0["volume_int"] as! Int, articleContent: $0["html_content"] as! String) // I am going to try to break this line down to simplify it and fix the build errors
                                
                            let lastItem = self.editorialObjects.count
                        }
                    }
                }
                    
                    let indexPaths = (lastItem..<self.editorialObjects.count).map { NSIndexPath(forItem: $0, inSection: $0) }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.editorialsTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade) // Animation implemented for testing, to be removed for version 1.0
                    }
                    
                    self.currentPage++
                }
            }
            
            self.populatingEditorials = false
            
        }
        
    }
        func handleRefresh() {
            
            refreshControl?.beginRefreshing()
            
            let currentNumberOfPages : Int = self.currentPage
            
            self.editorialObjects.removeAllObjects()
            
            self.currentPage = 1
            
            repeat {
            
                populateEditorials()
            
                self.currentPage++
            
            }
            
                while self.currentPage <= currentNumberOfPages
            
            self.editorialsTableView!.reloadData()
            
            refreshControl?.endRefreshing()
            
            populateEditorials()
        }
 }

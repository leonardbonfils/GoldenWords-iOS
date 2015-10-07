//
//  RandomTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class RandomTableViewController: UITableViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
//    
//    // Declaring data strings for labels in RandomTableViewController
//    
//    var randomHeadline = [String]()
//    var randomAuthor = [String]()
//    var randomPublishDate = [String]()
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton:UIBarButtonItem!

    // Refresh control variables - start
    
    // Table View Outlet used for the refresh control
    @IBOutlet var randomTableView: UITableView!
    
    var randomObjects = NSMutableArray()
    
    var customRefreshControl = UIRefreshControl?()
    
    var revealViewControllerIndicator : Int = 0
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingRandomArticles = false
    var currentPage = 1
    
    let RandomArticleTableCellIdentifier = "RandomTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()

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
        randomTableView.delegate = self
        randomTableView.dataSource = self
        
        // Creating and configuring the customRefreshControl subview
//        customRefreshControl = UIRefreshControl()
        customRefreshControl!.backgroundColor = goldenWordsYellow
        customRefreshControl!.tintColor = UIColor.whiteColor()
        customRefreshControl!.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        randomTableView.addSubview(customRefreshControl!)
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Random Articles"
        
        loadCustomRefreshContents()
        
        populateRandomArticles()
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.customRefreshControl!.attributedTitle = NSAttributedString(string: updateString)
        
//        // static data to test my table view controller
//        randomHeadline = ["Random Paris Article",
//                          "Random Berlin Article",
//                          "Random Madrid Article",
//                          "Random Moscow Article"]
//        
//        randomAuthor =   ["Daenerys Targaryen",
//                          "Jon Snow",
//                          "Jaime Lannister",
//                          "Arya Stark"]
//        
//        randomPublishDate = ["October 1st",
//                             "October 2nd",
//                             "October 3rd",
//                             "October 4th"]
        
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

    // MARK: - Table view data source

    
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
        customRefreshControl!.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomObjects.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("RandomTableCellIdentifier", forIndexPath: indexPath) as! RandomTableViewCell
        
        let row = indexPath.row
//        cell.randomHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        cell.randomHeadlineLabel.text = randomHeadline[row]
//        
//        cell.randomAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.randomAuthorLabel.text = randomAuthor[row]
//        
//        cell.randomPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.randomPublishDateLabel.text = randomPublishDate[row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(RandomArticleTableCellIdentifier, forIndexPath: indexPath) as! RandomTableViewCell
        
        let title = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).title
        let timeStamp = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).timeStamp
        let imageURL = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).imageURL
        let author = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).author
        
        let issueNumber = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).issueNumber
        let volumeNumber = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).volumeNumber
        
        let articleContent = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).articleContent
        
        // Unlike the Pictures Collection View, there is no need to create another Alamofire request here, since we already have all the content we want from the JSON we downloaded. There is no URL that we wish to place a request with to get extra content.
        
        cell.randomHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.randomHeadlineLabel.text = title
        
        cell.randomAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.randomAuthorLabel.text = author
        
        cell.randomPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.randomPublishDateLabel.text = timeStamp
        
        cell.randomVolumeAndIssueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.randomVolumeAndIssueLabel.text = "Volume \(volumeNumber) - Issue \(issueNumber)"
        
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
        
        if segue.identifier == "ShowRandomArticleDetails" {
            
            let detailViewController = segue.destinationViewController as! RandomDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath!.row
            
            // Passing the article information through the segue
            detailViewController.randomArticleTitleThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).title
            detailViewController.randomArticlePublishDateThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).timeStamp
            detailViewController.randomArticleVolumeIndexThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            detailViewController.randomArticleIssueIndexThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.randomArticleAuthorThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.randomArticleArticleContentThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).articleContent
            
//            detailViewController.randomArticleTitleThroughSegue = randomHeadline[row]
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8) {
            populateRandomArticles()
        }
    }
    
    func populateRandomArticles() {
        if populatingRandomArticles {
            return
        }
        
        populatingRandomArticles = true
        
        Alamofire.request(GWNetworking.Router.Random(self.currentPage)).responseJSON() {
            (request, response, result) in
            
            if result.error == nil {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    
                    // Making an array of all the node IDs from the JSON file
                    let nodeIDArray : [String]
                    var nodeCounter : Int = 0
                    for nodeCounter in 0..<9 {
                        
                        if let jsonValue = result.value {
                            
                            nodeIDArray[nodeCounter] = jsonValue{nodeCounter}.string
                            let randomArticleInfos : RandomElement = ((jsonValue as! NSDictionary).valueForKey("\(nodeIDArray[nodeCounter])") as! [NSDictionary]).map { RandomElement(title: $0["title"] as! String, nodeID: $0["nid"] as! Int, timeStamp: $0["revision_timestamp"] as! Int, imageURL: $0["image_url"] as! String, author: $0["author"], issueNumber: $0["issue_int"] as! Int, volumeNumber: $0["volume_int"] as! Int, articleContent: $0["html_content"] as! String) // I am going to try to break this line down to simplify it and fix the build errors
                                
                                let lastItem = self.randomObjects.count
                            }
                        }
                    }
                    
                    let indexPaths = (lastItem..<self.editorialObjects.count).map { NSIndexPath(forItem: $0, inSection: $0) }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.randomTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade) // Animation implemented for testing, to be removed for version 1.0
                    }
                    
                    self.currentPage++
                }
            }
            
            self.populatingRandomArticles = false
            
        }
        
    }
    func handleRefresh() {
        
        customRefreshControl?.beginRefreshing()
        
        let currentNumberOfPages : Int = self.currentPage
        
        self.randomObjects.removeAllObjects()
        
        self.currentPage = 1
        
        repeat {
            
            populateRandomArticles()
            // I initially thought I would need to add 1 to the currentPage everytime, but this is already done in the populateNewsArticles function, so there is no need to write it again.
            //                self.currentPage++
            
        }
            
            while self.currentPage <= currentNumberOfPages
        
        self.randomTableView!.reloadData()
        
        customRefreshControl?.endRefreshing()
        
        //            populateEditorials()
    }
}

//
//  NewsTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class NewsTableViewController: UITableViewController {

    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
//    // Declaring data strings for labels in NewsTableViewController
//    
//    var newsHeadline = [String]()
//    var newsAuthor = [String]()
//    var newsPublishDate = [String]()
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    
    // Refresh control variables - start
    
    // Table View Outlet used for the refresh control
    @IBOutlet var newsTableView: UITableView!
    
    var newsObjects = NSMutableArray()
        
    var customRefreshControl = UIRefreshControl?()
    
    var revealViewControllerIndicator : Int = 0
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingNewsArticle = false
    var currentPage = 1
    
    let newsArticleTableCellIdentifier = "NewsTableCellIdentifier"
    
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
        
        // Preliminary refresh "set up"
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        // Creating and configuring the customRefreshControl subview
//        customRefreshControl = UIRefreshControl()
        customRefreshControl!.backgroundColor = goldenWordsYellow
        customRefreshControl!.tintColor = UIColor.whiteColor()
        customRefreshControl!.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
        newsTableView.addSubview(customRefreshControl!)
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "News Articles"
        
        loadCustomRefreshContents()
        
        populateNewsArticles()
        
        // Formatting the date for the "last updated on..." string
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.customRefreshControl!.attributedTitle = NSAttributedString(string: updateString)
        
        
//        // static data to test my table view controller
//        
//        newsHeadline = ["News Paris",
//                        "News London",
//                        "News New York",
//                        "News San Francisco"]
//        
//        newsAuthor = ["Caesar",
//                      "Lucius Fox",
//                      "Steve Jobs",
//                      "Sundar Pichai"]
//        
//        newsPublishDate = ["August 1st",
//                           "August 2nd",
//                           "August 3rd",
//                           "August 4th"]
        
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

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return newsObjects.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("NewsTableCellIdentifier", forIndexPath: indexPath) as! NewsTableViewCell
//        
        let row = indexPath.row
//        cell.newsHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        cell.newsHeadlineLabel.text = newsHeadline[row]
//        
//        cell.newsAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.newsAuthorLabel.text = newsAuthor[row]
//        
//        cell.newsPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.newsPublishDateLabel.text = newsPublishDate[row]

            let cell = tableView.dequeueReusableCellWithIdentifier(newsArticleTableCellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
        
        let title = (newsObjects.objectAtIndex(indexPath.row) as! NewsElement).title
        let timeStamp = (newsObjects.objectAtIndex(indexPath.row) as! NewsElement).timeStamp
        let imageURL = (newsObjects.objectAtIndex(indexPath.row) as! NewsElement).imageURL
        let author = (newsObjects.objectAtIndex(indexPath.row) as! NewsElement).author
        
        let issueNumber = (newsObjects.objectAtIndex(indexPath.row) as! NewsElement).issueNumber
        let volumeNumber = (newsObjects.objectAtIndex(indexPath.row) as! NewsElement).volumeNumber
        
        let articleContent = (newsObjects.objectAtIndex(indexPath.row) as! NewsElement).articleContent
        
        
        cell.newsHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.newsHeadlineLabel.text = title
        
        cell.newsAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.newsAuthorLabel.text = author
        
        cell.newsPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.newsPublishDateLabel.text = String(timeStamp)
        
        cell.newsVolumeAndIssueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        cell.newsVolumeAndIssueLabel.text = "Volume \(volumeNumber) - Issue \(issueNumber)"
        
        
        return cell
    }



    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
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
        
        if segue.identifier == "ShowNewsArticleDetails" {
            
            let detailViewController = segue.destinationViewController as! NewsDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            // Passing the article information through the segue
            detailViewController.newsArticleTitleThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).title
            detailViewController.newsArticlePublishDateThroughSegue = String(newsObjects.objectAtIndex((myIndexPath?.row)!).timeStamp)
            detailViewController.newsArticleVolumeIndexThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            detailViewController.newsArticleIssueIndexThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.newsArticleAuthorThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.newsArticleArticleContentThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).articleContent

            
//            detailViewController.newsArticleTitleThroughSegue = newsHeadline[row!]
            
        }
        
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8) {
        populateNewsArticles()
        }
    }
    
    func populateNewsArticles() {
        if populatingNewsArticle {
            return
        }
        
        populatingNewsArticle = true
        
        
        Alamofire.request(GWNetworking.Router.News(self.currentPage)).responseJSON() { response in
            if let JSON = response.result.value {
            
            if response.result.error == nil {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    
                    // Making an array of all the node IDs from the JSON file
                    let nodeIDArray : [String]
                    var nodeCounter : Int = 0
                    for nodeCounter in 0..<9 {
                        
                        if let jsonValue = response.result.value {
                            
//                            nodeIDArray[nodeCounter] = jsonValue{nodeCounter}.string
//                            let newsArticleInfos : NewsElement = ((jsonValue as! NSDictionary).valueForKey("\(nodeIDArray[nodeCounter])") as! [NSDictionary]).map { NewsElement(title: $0["title"] as! String, nodeID: $0["nid"] as! Int, timeStamp: $0["revision_timestamp"] as! Int, imageURL: $0["image_url"] as! String, author: $0["author"], issueNumber: $0["issue_int"] as! Int, volumeNumber: $0["volume_int"] as! Int, articleContent: $0["html_content"] as! String) // I am going to try to break this line down to simplify it and fix the build errors
                            
                            }
                        }
                    }
                
                
                    let lastItem = self.newsObjects.count

                
                    let indexPaths = (lastItem..<self.newsObjects.count).map { NSIndexPath(forItem: $0, inSection: $0) }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.newsTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade) // Animation implemented for testing, to be removed for version 1.0
                    }
                    
                    self.currentPage++
                }
            }
            
            self.populatingNewsArticle = false
            
        }
        
    }
    
    func handleRefresh() {
        
        customRefreshControl?.beginRefreshing()
        
        let currentNumberOfPages : Int = self.currentPage
        
        self.newsObjects.removeAllObjects()
        
        self.currentPage = 1
        
        repeat {
        
            populateNewsArticles()
// I initially thought I would need to add 1 to the currentPage everytime, but this is already done in the populateNewsArticles function, so there is no need to write it again.
//            self.currentPage++
        
        }
        
            while self.currentPage <= currentNumberOfPages
        
        self.newsTableView!.reloadData()
        
        customRefreshControl?.endRefreshing()
        
//      populateEditorials()
        
    }
    
}
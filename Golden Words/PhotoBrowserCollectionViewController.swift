//
//  PhotoBrowserCollectionViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//


import UIKit
import Alamofire

class PhotoBrowserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    // Collection view outlet used for the refresh control
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    
    var photos = NSMutableArray()
    
    @IBOutlet weak var PhotoBrowserCell: PhotoBrowserCollectionViewCell!
    
    // an indicator used to know if the reveal view controller is currently shown (i.e. to know if the hamburger menu is open)
    var revealViewControllerIndicator : Int = 0
    
    let imageCache = NSCache()
    
    let refreshControl = UIRefreshControl()
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingPhotos = false
    var currentPage = 1
    
    let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
//    let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView" // Identifier used for the footer view (with Featured and Downloads)
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hamburger menu button setup
    if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280

        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        
        // Creating and configuring the refreshControl subview
        // The refresh control has already been declared outside of viewDidLoad()
//      refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = goldenWordsYellow
        refreshControl.tintColor = UIColor.whiteColor()
        picturesCollectionView.addSubview(refreshControl)
        
        loadCustomRefreshContents()
        
        setupView()
        
        populatePhotos()
        
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.refreshControl.attributedTitle = NSAttributedString(string: updateString)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = refreshControl.bounds
        
        for (var i=0; i < customView.subviews.count; i++) {
            labelsArray.append(customView.viewWithTag(i+1) as! UILabel)
            
            refreshControl.addSubview(customView)
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
                        if self.refreshControl.refreshing {
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
        if refreshControl.refreshing {
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
        refreshControl.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
//    
//    
//    let imageURL = (photos.objectAtIndex(indexPath.row) as! PictureElement).imageURL
//    
//    cell.imageView.image = nil
//    cell.request?.cancel()
//    
//    cell.request = Alamofire.request(.GET, imageURL).responseImage() {
//        (request, _, image, error) in
//        if error == nil && image != nil {
//        cell.imageView.image = image
//    
//        }
//    }
//    
//        return cell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        
        let imageURL = (photos.objectAtIndex(indexPath.row) as! PictureElement).imageURL
        
        cell.request?.cancel()
        
        // Using image cache system to make sure the table view works even when rapidly scrolling down the screen.
        if let image = self.imageCache.objectForKey(imageURL) as? UIImage {
            cell.imageView.image = image
            
        } else {
            
            cell.imageView.image = nil
            
            cell.request = Alamofire.request(.GET, imageURL).validate(contentType: ["image/*"]).responseImage() {
                (request, _, result) in
                if result.error == nil && result.value != nil {
                    
                    self.imageCache.setObject(result.value!, forKey: request!.URLString)
                    
                    cell.imageView.image = result.value
                } else {
                    
                }
            }
            
        }
        
        return cell
        
    }
    
//    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PhotoBrowserFooterViewIdentifier, forIndexPath: indexPath)
//    }
    

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowPhoto", sender: (self.photos.objectAtIndex(indexPath.item) as! PictureElement).nodeID)
    }
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.size.width - 2) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
//        layout.footerReferenceSize = CGSize(width: collectionView!.bounds.size.width, height: 100.0)
        
        collectionView!.collectionViewLayout = layout
        
        navigationItem.title = "Pictures"
        
        collectionView!.registerClass(PhotoBrowserCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PhotoBrowserCellIdentifier)
//        collectionView!.registerClass(PhotoBrowserCollectionViewLoadingCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoBrowserFooterViewIdentifier)
        
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        collectionView!.addSubview(refreshControl)
    }
    
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            (segue.destinationViewController as! PhotoViewerViewController).photoID = sender!.integerValue
            (segue.destinationViewController as! PhotoViewerViewController).hidesBottomBarWhenPushed = true
        }
        
        
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.8) {
            populatePhotos()
        }
    }
    
    func populatePhotos() { // This function can be used multiple times in a row to populate more photos since the "currentPage" index is increased by 1 at each iteration and the new photos are added to the "photos" set.
        if populatingPhotos {
            return
        }
        
        populatingPhotos = true
        
        // Check the "Photos" part
        Alamofire.request(GWNetworking.Router.Pictures(self.currentPage)).responseJSON() {
            (request, response, result) in
            
            if result.error == nil {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                
                
                // Making an array of all the node IDs from the JSON file
                let nodeIDArray : [String]
                var nodeCounter : Int = 0
                for  nodeCounter in 0..<9 {
                    
                    if let jsonValue = result.value {
                    
                        nodeIDArray[nodeCounter] = jsonValue{nodeCounter}.string // I am not sure what function to use to retrieve all the node IDs here. If I found an equivalent of valueForKey that just used the index position in the Dictionary, that would be perfect. I'm just using SwiftyJSON here.
                        let photoInfos : PictureElement = ((jsonValue as! NSDictionary).valueForKey("\(nodeIDArray[nodeCounter])") as! [NSDictionary]).map { PictureElement(title: $0["title"] as! String, nodeID: $0["nid"] as! Int, timeStamp: $0["revision_timestamp"] as! Int, imageURL: $0["image_url"] as! String, author: $0["author"] as! String, issueNumber: $0["issue_int"] as! Int, volumeNumber: $0["volume_int"] as! Int )} // Create objects of the class PictureElement that contain all the info from the JSON
                        
                        let lastItem = self.photos.count // getting the index of the lastItem before we add more photos (to facilitate adding more photos at the next populatePhotos() call
                        
                        self.photos.addObject(photoInfos) // adding all the objects to the "photos" set
                        
                    }
                }
            }
                
                let indexPaths = (lastItem..<self.photos.count).map { NSIndexPath(forItem: $0, inSection: $0) }

                
//                var subNodeCounter : Int = 0
//                for subNodeCounter in 0..<nodeIDArray.count {
//                    
//                    let photoInfos = ((JSON as! NSDictionary).valueForKey(nodeIDArray[nodeCounter]))
//                    nodecoun
//                    
//                }
                
//                let photoInfos = ((JSON as! NSDictionary).valueForKey("photos") as! [NSDictionary]).map { PictureElement(nodeID: $0["nid"] as! Int, imageURL: $0["image_url"] as! String)}
                
//                let lastItem = self.photos.count
//                
//                self.photos.addObject(photoInfos)
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView!.insertItemsAtIndexPaths(indexPaths)
                    }
                
                self.currentPage++
            }
        }
            self.populatingPhotos = false
    }
    
    
    
    func handleRefresh() {
        
        // This is where we decide what happens when we use the refresh control (pull to refresh)
        
        // We have to reload the data (i.e. get the new pictures from the server)
        
        refreshControl.beginRefreshing()
        
        let currentNumberOfPages : Int = self.currentPage
        
        self.photos.removeAllObjects()
        
        self.currentPage = 1
        
        repeat {
        
            populatePhotos()
        
            self.currentPage++
        
        }
        
            while self.currentPage <= currentNumberOfPages
        
        self.collectionView!.reloadData()
        
        refreshControl.endRefreshing()
        
        populatePhotos()
        
    }
}

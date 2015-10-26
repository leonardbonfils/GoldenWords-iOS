//
//  PhotoBrowserCollectionViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotoBrowserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet var picturesCollectionView: UICollectionView!

    var pictureObjects = NSMutableOrderedSet(capacity: 1000)
    
    // an indicator used to know if the reveal view controller is currently shown (i.e. to know if the hamburger menu is open)
    var revealViewControllerIndicator : Int = 0
    
    let imageCache = NSCache()
    
    var customRefreshControl = UIRefreshControl()
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingPhotos = false
    
    var currentPage = 0
    
    let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
    
    var dateFormatter = NSDateFormatter()
    
    var nodeIDArray = NSMutableArray()
    
    var timeStampDateString : String!
    
//    let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView" // Identifier used for the footer view (with Featured and Downloads)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.picturesCollectionView!.registerClass(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier:PhotoBrowserCellIdentifier)

        
        // Hamburger menu button setup
    if self.revealViewController() != nil {
        revealViewControllerIndicator = 1
        menuButton.target = self.revealViewController()
        menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280
        
        // Preliminary refresh control "set up"
        picturesCollectionView!.delegate = self
        picturesCollectionView!.dataSource = self
        
        // Creating and configuring the customRefreshControl subview
        customRefreshControl = UIRefreshControl()
        customRefreshControl.backgroundColor = goldenWordsYellow
        customRefreshControl.tintColor = UIColor.whiteColor()
        self.picturesCollectionView!.addSubview(customRefreshControl)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Pictures"
        
        loadCustomRefreshContents()
        
        setupView()
        
        populatePhotos()
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        /*
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.customRefreshControl.attributedTitle = NSAttributedString(string: updateString)
        */
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = customRefreshControl.bounds
        
        for (var i=0; i < customView.subviews.count; i++) {
            labelsArray.append(customView.viewWithTag(i+1) as! UILabel)
            
            customRefreshControl.addSubview(customView)
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
                        if self.customRefreshControl.refreshing {
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
        if customRefreshControl.refreshing {
            if !isAnimating {
                holdRefreshControl()
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
    
    func holdRefreshControl() {
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "handleRefresh", userInfo: nil, repeats: true)
    }
    
//    func endOfWork() {
//        customRefreshControl.endRefreshing()
//        
//        timer.invalidate()
//        timer = nil
//    }

    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureObjects.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        
        let cell = picturesCollectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        
        cell.imageView.image = UIImage(named: "mail")
        
        return cell
    }
        
        //
//    
//    let imageURL = (pictureObjects.objectAtIndex(indexPath.row) as! PictureElement).imageURL
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
        
//        guard let cell = picturesCollectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as? PhotoBrowserCollectionViewCell else {
//            
//            print("cell could not be initialized as PhotoBrowserCollectionViewCell, hence it will be casted to another default UICollectionViewCell type")
//            return picturesCollectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath)
//            
//            
//        }
        
//        let cell = picturesCollectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
//        
//        if let photoObject = pictureObjects.objectAtIndex(indexPath.row) as? PictureElement {
//            
//            let title = photoObject.title ?? "" // if photoObject.title == nil, then we return an empty string
//            
//            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(photoObject.timeStamp))
//            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject)
//            
//            let author = photoObject.author ?? ""
//            
//            let issueNumber = photoObject.issueNumber ?? ""
//            let volumeNumber = photoObject.volumeNumber ?? ""
//            
//            let nodeID = photoObject.nodeID ?? 0
//            
//            let imageURL = photoObject.imageURL ?? ""
//            
//            cell.request?.cancel()
//            
//            // Using image cache system to make sure the table view works even when rapidly scrolling down the screen.
//            if let image = self.imageCache.objectForKey(imageURL) as? UIImage {
//                
//                cell.imageView.image = image
//                
//            } else {
//                
//                cell.imageView.image = nil
//                cell.request = Alamofire.request(.GET, imageURL).responseImage() { response in
//                    if let image = response.result.value {
////                        self.imageCache.setObject(response.result.value!, forKey: response.request!.URLString)
//                        self.imageCache.setObject(response.result.value!, forKey: imageURL)
//                        cell.imageView.image = image
//                        
//                    } else {
//                    }
//                }
//            }
//        } else {
//    }
        
        
        
        

        
//        cell.request?.cancel()
//        
//        // Using image cache system to make sure the table view works even when rapidly scrolling down the screen.
//        if let image = self.imageCache.objectForKey(imageURL) as? UIImage {
//
//            cell.imageView.image = image
//            
//        } else {
//            
//            cell.imageView.image = nil
//            
//            cell.request = Alamofire.request(.GET, imageURL).responseImage { response in
//                
//                if let image = response.result.value {
//                    
//                    self.imageCache.setObject(response.result.value!, forKey: response.request!.URLString)
//                    
//                    cell.imageView.image = image
//                    
//                } else {
//                    
//                }
//                
//                
//            }
//   
////            cell.request = Alamofire.request(.GET, imageURL).validate(contentType: ["image/*"]).responseImage() {
////                (request, _, result) in
////                if result.error == nil && result.value != nil {
////                    
////                    self.imageCache.setObject(result.value!, forKey: request!.URLString)
////                    
////                    cell.imageView.image = result.value
////                } else {
////                    
////                }
////            }

    
    
/*
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PhotoBrowserFooterViewIdentifier, forIndexPath: indexPath)
    }

*/
    

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowPhoto", sender: (self.pictureObjects.objectAtIndex(indexPath.item) as! PictureElement).imageURL)
    }
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Configuring out collection view flow layout
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.size.width - 2) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
//        layout.footerReferenceSize = CGSize(width: picturesCollectionView!.bounds.size.width, height: 100.0)
        
        picturesCollectionView!.collectionViewLayout = layout
        
        navigationItem.title = "Pictures"
        
//        picturesCollectionView!.registerClass(PhotoBrowserCollectionViewLoadingCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PhotoBrowserFooterViewIdentifier)
        
        customRefreshControl.tintColor = UIColor.whiteColor()
        customRefreshControl.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
        self.picturesCollectionView!.addSubview(customRefreshControl)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(120, 120)
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            
            let detailViewController = segue.destinationViewController as! PhotoViewerViewController
            let myIndexPath = self.picturesCollectionView?.indexPathForCell(sender as! UICollectionViewCell)
            let row = myIndexPath?.row
            
            detailViewController.imageURLForViewerController = sender!.stringValue
            
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.25) {
            populatePhotos()
        }
    }
    
    func populatePhotos() {
        
/* This function can be used multiple times in a row to populate more photos since the "currentPage" index is increased by 1 at each iteration and the new photos are added to the "photos" set. */
        
        if populatingPhotos {
            return
        }
        populatingPhotos = true
        // Check the "Photos" part
        Alamofire.request(GWNetworking.Router.Pictures(self.currentPage)).responseJSON() { response in
            
            if let JSON = response.result.value {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                
                var nodeIDArray : [Int]
                if (JSON .isKindOfClass(NSDictionary)) {
                    
                    for node in JSON as! Dictionary<String, AnyObject> {
                        let nodeIDValue = node.0
                        var lastItem : Int = 0
                        self.nodeIDArray.addObject(nodeIDValue)
                        if let pictureElement : PictureElement = PictureElement(title: "init", nodeID: 0, timeStamp: 0, imageURL: "init", author: "init", issueNumber: "init", volumeNumber: "init") {
                            
                            pictureElement.title = node.1["title"] as! String
                            pictureElement.nodeID = Int(nodeIDValue)!
                            
                            let timeStampString = node.1["revision_timestamp"] as! String
                            pictureElement.timeStamp = Int(timeStampString)!
                            
                            pictureElement.imageURL = String(node.1["image_url"])
                            pictureElement.author = String(node.1["author"]) as! String
                            pictureElement.issueNumber = String(node.1["issue_int"])
                            pictureElement.volumeNumber = String(node.1["volume_int"])
                            
                            lastItem = self.pictureObjects.count
                            self.pictureObjects.addObject(pictureElement)
                            let timeStampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                            self.pictureObjects.sortUsingDescriptors([timeStampSortDescriptor])
                            let indexPaths = (lastItem..<self.pictureObjects.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                        }
                        // print(self.pictureObjects.count)
                        // print(self.pictureObjects)
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.picturesCollectionView.reloadData()
                }
                self.currentPage++
            }
        }
            self.populatingPhotos = false
    }
}
    
    
    
    func handleRefresh() {
        
        // This is where we decide what happens when we use the refresh control (pull to refresh)
        
        // We have to reload the data (i.e. get the new pictures from the server)
        
        customRefreshControl.beginRefreshing()
        
//        let currentNumberOfPages : Int = self.currentPage
//        
//        self.pictureObjects.removeAllObjects()
        
        self.currentPage = 0
        
//        repeat {
//        
//            populatePhotos()
//        
//            self.currentPage++
//        
//        }
//        
//            while self.currentPage <= currentNumberOfPages

        self.populatingPhotos = false
        
        populatePhotos()
        
//        self.picturesCollectionView!.reloadData()
        
        customRefreshControl.endRefreshing()
        
//        populatePhotos()
        
    }
}

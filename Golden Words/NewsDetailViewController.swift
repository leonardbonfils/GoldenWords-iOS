    //
//  NewsDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-29.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    @IBOutlet weak var newsDetailNavigationItem: UINavigationItem!
    
    var newsArticleTitleThroughSegue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inserting the selected news article's title
        newsDetailNavigationItem.title = newsArticleTitleThroughSegue
        
        // "Swipe from left edge" recognizer
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleSwipes (sender: UISwipeGestureRecognizer) {
        
        if (sender.direction == .Left) {
            
            print("Swipe left")
        }
        
        if (sender.direction == .Right) {
            
            print("Swipe right")
            
        }
        
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

//
//  Article+CoreDataProperties.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-19.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Article {

    @NSManaged var articleTitle: String?
    @NSManaged var articleAuthor: String?
    @NSManaged var articleVolumeNumber: String?
    @NSManaged var articleIssueNumber: String?
    @NSManaged var articleTimeStamp: NSNumber?
    @NSManaged var articleArticleContent: String?
    @NSManaged var articleImageURL: String?

}

//
//  Source.swift
//  InstaNews
//
//  Created by Suniel on 10/13/17.
//  Copyright © 2017 Suniel. All rights reserved.
//


import CoreData

class Source : NSManagedObject {
    
    
    @NSManaged  var title: String?
    @NSManaged  var image: NSData?
    @NSManaged  var category: String?
    
    
}


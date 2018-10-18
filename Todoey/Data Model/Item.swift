//
//  Item.swift
//  Todoey
//
//  Created by Amanda Ramirez on 10/16/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // relationship
    // each item will have a parent Category 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}




















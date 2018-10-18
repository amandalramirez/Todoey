//
//  Category.swift
//  Todoey
//
//  Created by Amanda Ramirez on 10/16/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    // forward relationship
    // a group of items (of type item) will be in a single list (parent category)
    // i.e. each category will have a list of items 
    let items = List<Item>()
}

//
//  Item.swift
//  Todoey
//
//  Created by Amanda Ramirez on 9/19/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import Foundation

//Encodable + Decodable = Codable
class Item: Codable {
    var title : String = ""
    var done : Bool = false
}

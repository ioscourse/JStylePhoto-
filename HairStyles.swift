//
//  HairStyles.swift
//  JStyle
//
//  Created by Charles Konkol on 2015-06-04.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import Foundation
import CoreData

class HairStyles: NSManagedObject {

    @NSManaged var fullname: String
    @NSManaged var photo: NSData
    @NSManaged var scale: String

}

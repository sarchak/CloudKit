//
//  Todos.swift
//  CloudKit
//
//  Created by Shrikar Archak on 10/14/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import Foundation
import CloudKit

class Todos : NSObject{
    var record : CKRecord!
    var todotext : String!
    weak var database : CKDatabase!
    var date: NSDate
    init(record : CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        self.todotext = record.objectForKey("todotext") as String!
        self.date = record.creationDate
    }

}
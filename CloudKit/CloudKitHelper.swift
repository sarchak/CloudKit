//
//  CloudKitHelper.swift
//  CloudKit
//
//  Created by Shrikar Archak on 10/12/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitHelper {
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase

    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func saveRecord(todo : NSString) {
        let todoRecord = CKRecord(recordType: "Todos")
        todoRecord.setValue(todo, forKey: "todotext")
        publicDB.saveRecord(todoRecord, completionHandler: { (record, error) -> Void in
            NSLog("Saved to cloud kit")
            
        })

    }
}
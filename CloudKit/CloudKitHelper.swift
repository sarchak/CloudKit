//
//  CloudKitHelper.swift
//  CloudKit
//
//  Created by Shrikar Archak on 10/12/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}


class CloudKitHelper {
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    var delegate : CloudKitDelegate?
    var todos = [Todos]()
    
    class func sharedInstance() -> CloudKitHelper {
        return cloudKitHelper
    }

    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func saveRecord(todo : NSString) {
        let todoRecord = CKRecord(recordType: "Todos")
        todoRecord.setValue(todo, forKey: "todotext")
//        let ops = CKModifyRecordsOperation(recordsToSave: [todoRecord], recordIDsToDelete: nil)
//        ops.savePolicy = CKRecordSavePolicy.AllKeys
//        
//        ops.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
//            NSLog("Completed Save to cloud")
//            NSLog("===")
//            for it in savedRecords{
//                let r = it as CKRecord
//                let tmp = r.objectForKey("todotext")
//                NSLog("XXXXX : \(tmp)")
//            }
//            NSLog("===")
//            let predicate = NSPredicate(value: true)
//            let query = CKQuery(recordType: "Todos",
//                predicate:  predicate)
//
//            self.publicDB.performQuery(query, inZoneWithID: nil) {
//                results, error in
//                if error != nil {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.delegate?.errorUpdating(error)
//                        return
//                    }
//                } else {
//                    self.todos.removeAll()
//                    for record in results{
//                        
//                        let todo = Todos(record: record as CKRecord, database: self.publicDB)
//                        self.todos.append(todo)
//                        
//                    }
//                    NSLog("fetch after save : \(self.todos.count)")
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.delegate?.modelUpdated()
//                        return
//                    }
//                }
//            }
//        }
//        publicDB.addOperation(ops)

        publicDB.saveRecord(todoRecord, completionHandler: { (record, error) -> Void in
            NSLog("Before saving in cloud kit : \(self.todos.count)")
            NSLog("Saved in cloudkit")
            self.fetchTodos(record)
        })

    }
    
    func fetchTodos(insertedRecord: CKRecord?) {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        
        let query = CKQuery(recordType: "Todos",
            predicate:  predicate)
        query.sortDescriptors = [sort]
        publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.errorUpdating(error)
                    return
                }
            } else {
                self.todos.removeAll()
                for record in results{
                    let todo = Todos(record: record as CKRecord, database: self.publicDB)
                    self.todos.append(todo)
                }
                if let tmp = insertedRecord {
                    let todo = Todos(record: insertedRecord! as CKRecord, database: self.publicDB)
                    self.todos.insert(todo, atIndex: 0)
                }
                NSLog("fetch after save : \(self.todos.count)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.modelUpdated()
                    return
                }
            }
        }
    }
}
let cloudKitHelper = CloudKitHelper()

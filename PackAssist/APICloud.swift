//
//  APICloud.swift
//  PackAssist
//
//  Created by Rick Stoner on 3/27/17.
//  Copyright © 2017 Rick Stoner. All rights reserved.
//

import Foundation
import CloudKit

typealias APICloudCompletion = (_ success: Bool) -> ()

class APICloud {
    
    static let share = APICloud()
    
    let container: CKContainer
    let database: CKDatabase
    
    fileprivate init() {
        self.container = CKContainer.default()
        self.database = self.container.privateCloudDatabase
        
    }
    
    func write(trip: Trip, completion: @escaping APICloudCompletion) {
        let tripRecord = CKRecord(recordType: "Trips")
        
        tripRecord.setValue(trip.tripName, forKey: "tripName")
        tripRecord.setValue(trip.startDate, forKey: "startDate")
        tripRecord.setValue(trip.endDate, forKey: "endDate")
        self.database.save(tripRecord) { (record, error) in
            if let error = error {
                print("Error saving to iCloud", error)
                return
            }
            completion(true)
        }
    }
    
    func GETTrips(_ completion: @escaping (_ trip: [Trip]?) -> ()) {
        let query = CKQuery(recordType: "Trips", predicate: NSPredicate(value: true))
        self.database.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            if let error = error {
                print("Error getting record, ", error)
                return
            }
            if let records = records {
                var trips = [Trip]()
                
                for record in records {
                    let recordID = record.recordID
                    let tripName = record.value(forKey: "tripName") as? String
                    let startDate = record.value(forKey: "startDate") as? Date
                    let endDate = record.value(forKey: "endDate") as? Date
                    
                    if let tripName = tripName, let startDate = startDate, let endDate = endDate {
                        let trip = Trip(recordID: recordID, tripName: tripName, startDate: startDate, endDate: endDate)
                        trips.append(trip)
                    }
                }
                OperationQueue.main.addOperation {
                    completion(trips)
                }
            }
        })
    }
    
    func deleteRecord(item: CKRecordID, completion: @escaping APICloudCompletion) {
        self.database.delete(withRecordID: item) { (recordID, error) in
            if let error = error {
                print("Error deleting record ", error)
                return
            }
            OperationQueue.main.addOperation {
                completion(true)
                print("Record deleted")
            }
        }
    }
    
    
    
}


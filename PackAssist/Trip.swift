//
//  Trip.swift
//  PackAssist
//
//  Created by Rick Stoner on 3/28/17.
//  Copyright © 2017 Rick Stoner. All rights reserved.
//

import Foundation
import CloudKit

class Trip {
    
    let recordID: CKRecordID?
    var tripName: String
//    var destination: Destination
    var startDate: Date
    var endDate: Date
//    var packingList: [PackingList]
    
    init (recordID: CKRecordID?, tripName: String, startDate: Date, endDate: Date) {
        self.recordID = recordID
        self.tripName = tripName
//        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
//        self.packingList = packingList
    }
    
}

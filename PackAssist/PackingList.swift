//
//  PackingList.swift
//  PackAssist
//
//  Created by Rick Stoner on 3/28/17.
//  Copyright © 2017 Rick Stoner. All rights reserved.
//

import Foundation

class PackingList {
    
    let packItem: [String: Bool]
    
    init(packItem: String) {
        self.packItem = [packItem: false]
    }
    
}

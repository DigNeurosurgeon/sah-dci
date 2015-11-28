//
//  Status.swift
//  Interactive Risk Inventory System
//  Unique identifier: eu.dign.iRIS
//
//  Created by Pieter Kubben on 07-05-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class Status {
    
    let version: String
    let description: String
    let hasIssue: Bool
    let lastDateOfLocalSave: NSDate
    
    init(version: String?, description: String?, issueValue: Int?) {
        self.version  = version ?? ""
        self.description  = description ?? ""
        self.hasIssue = (issueValue == 1) ? true : false
        self.lastDateOfLocalSave = NSDate()
    }
    
}
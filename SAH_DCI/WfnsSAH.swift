//
//  WfnsSAH.swift
//
//  Required classes: none
//
//  Reference: 
//  http://radiopaedia.org/articles/wfns-grading-system
//  Last accessed: Sep 1, 2015
//
//  Created by Pieter Kubben on 11-08-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class WfnsSAH {
    
    // MARK:- Variables
    
    enum GCS: String {
        case Unselected = ""
        case EMV15 = "15"
        case EMV13_14 = "13 - 14"
        case EMV7_12 = "7 - 12"
        case EMV3_6 = "3 - 6"
    }
    
    enum MotorDeficit: String {
        case Unselected = ""
        case No = "No"
        case Yes = "Yes"
    }
    
    
    static let sections = ["Glasgow Coma Scale", "Motor deficit"]
    static let items = [
        [GCS.EMV15.rawValue, GCS.EMV13_14.rawValue, GCS.EMV7_12.rawValue, GCS.EMV3_6.rawValue],
        [MotorDeficit.No.rawValue, MotorDeficit.Yes.rawValue]
    ]
    
    var gcs: GCS
    var motorDeficit: MotorDeficit
    var selectedCellIndices: [Int]
    var final: Int {
        get {
            return calculateGrade()
        }
    }
    
    
    // MARK:- Methods
    
    init(gcs: GCS = GCS.Unselected, motorDeficit: MotorDeficit = MotorDeficit.Unselected) {
        self.gcs = gcs
        self.motorDeficit = motorDeficit
        
        self.selectedCellIndices = []
        for _ in WfnsSAH.sections {
            selectedCellIndices.append(-1)
        }
    }
    
    func calculateGrade() -> Int {
        
        var grade = 0
        
        switch gcs {
            case GCS.EMV15:
                grade = 1
            case GCS.EMV13_14:
                grade = motorDeficit == MotorDeficit.No ? 2 : 3
            case GCS.EMV7_12:
                grade = 4
            case GCS.EMV3_6:
                grade = 5
            default:
                grade = -100
        }
        
        if motorDeficit == MotorDeficit.Unselected {
            grade = -100
        }
        
        return grade
    }
    
}
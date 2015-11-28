//
//  HuntHess.swift
//
//  Required classes: none
//
//  Reference: 
//  http://radiopaedia.org/articles/hunt-and-hess-grading-system
//  Last accessed: Aug 30, 2015
//
//  Created by Pieter Kubben on 30-08-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class HuntHess {
    
    enum Grading: String {
        case Unselected = "Unselected"
        case Grade1 = "Asymptomatic or minimal headache and slight neck stiffness"
        case Grade2 = "Moderate to severe headache; neck stiffness; no neurologic deficit except cranial nerve palsy"
        case Grade3 = "Drowsy; minimal neurologic deficit"
        case Grade4 = "Stuporous; moderate to severe hemiparesis; possibly early decerebrate rigidity and vegetative disturbances"
        case Grade5 = "Deep coma; decerebrate rigidity; moribund"
    }
    
    var grading: Grading
    var grade: Int
    var survivalPercentage: Int
    var selectedCellIndices: [Int]
    
    var final: Int {
        get {
            return grade
        }
    }
    
    init(grading: Grading = .Unselected) {
        self.grading = grading
        
        switch grading {
        case .Grade1:
            grade = 1
            survivalPercentage = 70
        case .Grade2:
            grade = 2
            survivalPercentage = 60
        case .Grade3:
            grade = 3
            survivalPercentage = 50
        case .Grade4:
            grade = 4
            survivalPercentage = 20
        case .Grade5:
            grade = 5
            survivalPercentage = 10
        default:
            grade = -1
            survivalPercentage = -1
        }
        
        self.selectedCellIndices = []
        for _ in VASOGRADE.sections {
            selectedCellIndices.append(-1)
        }
    }
    
}
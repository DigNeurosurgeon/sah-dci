//
//  ModifiedFisher.swift
//
//  Required classes: none
//
//  Reference: 
//  Frontera, J. A., & Claassen, J. (2006).
//  PREDICTION OF SYMPTOMATICVASOSPASM AFTER SUBARACHNOID HEMORRHAGE: THE MODIFIED FISHER SCALE. 
//  Neurosurgery, 59(3), 529–538. http://doi.org/10.1227/01.NEU.0000228680.22550.A2
//
//  Created by Pieter Kubben on 11-08-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class ModifiedFisher {
    
    // MARK:- Variables
    
    enum SAH: String {
        case Unselected = ""
        case None = "None"
        case Thin = "Thin"
        case Thick = "Thick"
    }
    
    enum IVH: String {
        case Unselected = ""
        case No = "No"
        case Yes = "Yes"
        case Thin = "Thin"
        case Thick = "Thick"
    }
    
    static let sections = ["Subarachnoid hemorrhage", "Intraventricular hemorrhage"]
    static let items = [
        [SAH.None.rawValue, SAH.Thin.rawValue, SAH.Thick.rawValue],
        [IVH.No.rawValue, IVH.Yes.rawValue]
    ]
    static let detailItems = [
        [SAH.None.rawValue, SAH.Thin.rawValue, SAH.Thick.rawValue],
        [IVH.No.rawValue, IVH.Thin.rawValue, IVH.Thick.rawValue]
    ]
    
    var sah: SAH
    var ivh: IVH
    var ivhPresent: Bool
    var thickIVHPresent: Bool
    var selectedCellIndices: [Int]
    var final: Int {
        get {
            return calculateFinalScore()
        }
    }
    
    
    // MARK:- Methods
    
    
    init(sah: SAH = SAH.Unselected, ivh: IVH = IVH.Unselected) {
        self.sah = sah
        self.ivh = ivh
        
        switch ivh {
            case IVH.Thick:
                ivhPresent = true
                thickIVHPresent = true
            case IVH.Yes, IVH.Thin:
                ivhPresent = true
                thickIVHPresent = false // if IVH.Yes, we do not know and do not assume
            case IVH.No:
                ivhPresent = false
                thickIVHPresent = false
            default:
                ivhPresent = false
                thickIVHPresent = false
        }
        
        self.selectedCellIndices = []
        for _ in ModifiedFisher.sections {
            selectedCellIndices.append(-1)
        }
    }
    
    
    
    
    
    func calculateFinalScore() -> Int {
        
        var score = 0
        
        switch sah {
            case SAH.Thick:
                score = ivhPresent ? 4 : 3
            case SAH.Thin:
                score = ivhPresent ? 2 : 1
            case SAH.None:
                score = ivhPresent ? 2 : 0
            default:
                score = -100
        }
        
        if ivh == IVH.Unselected {
            score = -100
        }
        
        return score
    }
    
    
    static func oddsRatioForSymptomaticVasospasm(score: Int) -> String {
        
        var oddsRatio = ""
        
        switch score {
            case 0, 1:
                oddsRatio = "1"
            case 2:
                oddsRatio = "1.6 (95% CI 1.0 - 2.5)"
            case 3:
                oddsRatio = "1.6 (95% CI 1.1 - 2.2)"
            case 4:
                oddsRatio = "2.2 (95% CI 1.6 - 3.1)"
            default:
                break
        }
        
        return oddsRatio
    }
    
}
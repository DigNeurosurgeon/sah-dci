//
//  Fisher.swift
//
//  Required classes: none
//
//  Reference: 
//  Frontera, J. A., & Claassen, J. (2006).
//  PREDICTION OF SYMPTOMATICVASOSPASM AFTER SUBARACHNOID HEMORRHAGE: THE MODIFIED FISHER SCALE.
//  Neurosurgery, 59(3), 529–538. http://doi.org/10.1227/01.NEU.0000228680.22550.A2
//
//  Created by Pieter Kubben on 31-08-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class Fisher {
    
    // MARK:- Variables
    
    enum SAH: String {
        case Unselected = ""
        case None = "None"
        case LocalizedThin = "Localized Thin"
        case DiffuseThin = "Diffuse Thin"
        case LocalizedThick = "Localized Thick"
        case DiffuseThick = "Diffuse Thick"
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
        [SAH.None.rawValue, SAH.LocalizedThin.rawValue, SAH.DiffuseThin.rawValue, SAH.LocalizedThick.rawValue, SAH.DiffuseThick.rawValue],
        [IVH.No.rawValue, IVH.Yes.rawValue]
    ]
    static let detailItems = [
        [SAH.None.rawValue, SAH.LocalizedThin.rawValue, SAH.DiffuseThin.rawValue, SAH.LocalizedThick.rawValue, SAH.DiffuseThick.rawValue],
        [IVH.No.rawValue, IVH.Thin.rawValue, IVH.Thick.rawValue]
    ]
    
    var sah: SAH
    var ivh: IVH
    var ivhPresent: Bool
    var thickIVHPresent: Bool
    var selectedCellIndices: [Int]
    var final: Int {
        get {
            return calculateOriginalFisherScoreValue()
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
        for _ in Fisher.sections {
            selectedCellIndices.append(-1)
        }
    }
    
    
    func calculateOriginalFisherScoreValue() -> Int {
        
        var value = 0
        
        switch sah {
        case SAH.DiffuseThick:
            value = ivhPresent ? 3 : 3
        case SAH.LocalizedThick:
            value = ivhPresent ? 3 : 3
        case SAH.DiffuseThin:
            value = ivhPresent ? 4 : 2
        case SAH.LocalizedThin:
            value = ivhPresent ? 4 : 1
        case SAH.None:
            value = ivhPresent ? 4 : 1
        default:
            value = -100
        }
        
        if ivh == IVH.Unselected {
            value = -100
        }
        
        return value
    }
    
    
    func calculateModifiedFisherScore() -> ModifiedFisher {
        var modifiedSAH: ModifiedFisher.SAH
        let modifiedIVH = ModifiedFisher.IVH(rawValue: ivh.rawValue)
        
        switch sah {
        case SAH.DiffuseThick, SAH.LocalizedThick:
            modifiedSAH = ModifiedFisher.SAH.Thick
        case SAH.DiffuseThin, SAH.LocalizedThin:
            modifiedSAH = ModifiedFisher.SAH.Thin
        case SAH.None:
            modifiedSAH = ModifiedFisher.SAH.None
        default:
            modifiedSAH = ModifiedFisher.SAH.Unselected
        }
        
        let modifiedFisherScore = ModifiedFisher(sah: modifiedSAH, ivh: modifiedIVH!)
        return modifiedFisherScore
    }
    
    
    func calculateModifiedFisherScoreValue() -> Int {
        var value = 0
        
        switch sah {
        case SAH.DiffuseThick, SAH.LocalizedThick:
            value = ivhPresent ? 4 : 3
        case SAH.DiffuseThin, SAH.LocalizedThin:
            value = ivhPresent ? 2 : 1
        case SAH.None:
            value = ivhPresent ? 2 : 0
        default:
            value = -100
        }
        
        if ivh == IVH.Unselected {
            value = -100
        }
        
        return value
    }
    
}
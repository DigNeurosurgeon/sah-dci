//
//  Advanced.swift
//
//  Required classes: Fisher, ModifiedFisher, WfnsSAH, HuntHess, VASOGRADE
//  
//  References:
//  De Rooij, N. K., Greving, J. P., Rinkel, G. J. E., & Frijns, C. J. M. (2013). 
//  Early prediction of delayed cerebral ischemia after subarachnoid hemorrhage: 
//  Development and validation of a practical risk chart.
//  Stroke. http://doi.org/10.1161/STROKEAHA.113.001125
//
//  Jabbarli, R., Reinhard, M., Roelz, R., Shah, M., Niesen, W.-D., Kaier, K., … Van Velthoven, V. (2015). 
//  Early identification of individuals at high risk for cerebral infarction after aneurysmal subarachnoid hemorrhage: 
//  the BEHAVIOR score. 
//  Journal of Cerebral Blood Flow & Metabolism, (February), 1–6. http://doi.org/10.1038/jcbfm.2015.81
//
//  Created by Pieter Kubben on 28-08-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class Advanced {
    
    // MARK: - Variables
    
    enum Age: String {
        case Unselected = "Unselected"
        case Young = "Age < 55 years"
        case Old = "Age \u{2265} 55 years"
    }
    
    enum EarlyVasospasmOnDSA: String {
        case Unselected = "Unselected"
        case Yes = "Yes"
        case No = "No"
    }
    
    enum IntracranialPressure: String {
        case Unselected = "Unselected"
        case Normal = "ICP \u{2264} 20mm Hg"
        case Increased = "ICP > 20mm Hg"
    }
    
    enum TreatmentOfMultipleAneurysms: String {
        case Unselected = "Unselected"
        case Yes = "Yes"
        case No = "No"
    }
    
    enum NeedForExternalVentricularShunt: String {
        case Unselected = "Unselected"
        case Yes = "Yes"
        case No = "No"
    }
    
    static let sections = WfnsSAH.sections + Fisher.sections + ["Age", "Early vasospasm on DSA", "Intracranial Pressure", "Treatment of multiple aneurysms", "Hunt & Hess grade",  "Need for external ventricular shunt"]
    
    static let items = WfnsSAH.items + Fisher.detailItems + [
        [Age.Young.rawValue, Age.Old.rawValue],
        [EarlyVasospasmOnDSA.No.rawValue, EarlyVasospasmOnDSA.Yes.rawValue],
        [IntracranialPressure.Normal.rawValue, IntracranialPressure.Increased.rawValue],
        [TreatmentOfMultipleAneurysms.No.rawValue, TreatmentOfMultipleAneurysms.Yes.rawValue],
        [HuntHess.Grading.Grade1.rawValue, HuntHess.Grading.Grade2.rawValue, HuntHess.Grading.Grade3.rawValue, HuntHess.Grading.Grade4.rawValue, HuntHess.Grading.Grade5.rawValue],
        [NeedForExternalVentricularShunt.No.rawValue, NeedForExternalVentricularShunt.Yes.rawValue]
    ]
    
    var wfnsSahGrade: WfnsSAH
    var fisherScore: Fisher
    var age: Age
    var aged55OrOlder: Bool
    var vasospasm: EarlyVasospasmOnDSA
    var earlyVasospasmOnDSA: Bool
    var icp: IntracranialPressure
    var elevatedICP: Bool
    var multipleAneurysms: TreatmentOfMultipleAneurysms
    var treatmentOfMultipleAneurysms: Bool
    var huntHessGrade: HuntHess
    var evs: NeedForExternalVentricularShunt
    var needForExternalVentricularShunt: Bool
    
    var selectionOfComponentsIsComplete: Bool
    var selectedCellIndices: [Int]
    
    
    // MARK: - Init
    
    
    init(wfnsSahGrade: WfnsSAH = WfnsSAH(), fisherScore: Fisher = Fisher(), age: Age = Age.Unselected, vasospasm: EarlyVasospasmOnDSA = EarlyVasospasmOnDSA.Unselected, icp: IntracranialPressure = IntracranialPressure.Unselected, multipleAneurysms: TreatmentOfMultipleAneurysms = TreatmentOfMultipleAneurysms.Unselected, huntHessGrade: HuntHess = HuntHess(), evs: NeedForExternalVentricularShunt = NeedForExternalVentricularShunt.Unselected) {
        
        self.wfnsSahGrade = wfnsSahGrade
        self.fisherScore = fisherScore
        
        self.age = age
        self.aged55OrOlder = age == Age.Old ? true : false
        
        self.vasospasm = vasospasm
        self.earlyVasospasmOnDSA = vasospasm == EarlyVasospasmOnDSA.Yes ? true : false

        self.icp = icp
        self.elevatedICP = icp == IntracranialPressure.Increased ? true : false

        self.multipleAneurysms = multipleAneurysms
        self.treatmentOfMultipleAneurysms = multipleAneurysms == TreatmentOfMultipleAneurysms.Yes ? true : false
        self.huntHessGrade = huntHessGrade
        
        self.evs = evs
        self.needForExternalVentricularShunt = evs == NeedForExternalVentricularShunt.Yes ? true : false
        
        if (wfnsSahGrade.final < 0 || fisherScore.calculateOriginalFisherScoreValue() < 0 || fisherScore.calculateModifiedFisherScoreValue() < 0 || age == Age.Unselected ||
            vasospasm == EarlyVasospasmOnDSA.Unselected || icp == IntracranialPressure.Unselected ||
            multipleAneurysms == TreatmentOfMultipleAneurysms.Unselected || huntHessGrade.final < 0 ||
            evs == NeedForExternalVentricularShunt.Unselected) {
                
            // Not all components have been selected
            selectionOfComponentsIsComplete = false
        } else {
            selectionOfComponentsIsComplete = true
        }
        
        self.selectedCellIndices = []
        for _ in Advanced.sections {
            selectedCellIndices.append(-1)
        }
    }
    
    
    // MARK: - Calculate risks
    
    
    private func calculateRiskPercentageFromRiskChart() -> Int {
        var riskPercentage = -1
        let modifiedFisherScoreValue = fisherScore.calculateModifiedFisherScoreValue()
        let wfnsSahGradeValue = wfnsSahGrade.final
        let thickIVHPresent = fisherScore.thickIVHPresent
        
        if modifiedFisherScoreValue >= 0 && modifiedFisherScoreValue <= 2 {
            // Left column
            
            if aged55OrOlder {
                // Upper left quadrant
                switch wfnsSahGradeValue {
                case 1:
                    riskPercentage = thickIVHPresent ? 17 : 12
                case 2, 3:
                    riskPercentage = thickIVHPresent ? 22 : 15
                case 4:
                    riskPercentage = thickIVHPresent ? 24 : 17
                case 5:
                    riskPercentage = thickIVHPresent ? 39 : 29
                default:
                    break
                }
                
            } else {
                // Lower left quadrant
                switch wfnsSahGradeValue {
                case 1:
                    riskPercentage = thickIVHPresent ? 22 : 15
                case 2, 3:
                    riskPercentage = thickIVHPresent ? 28 : 20
                case 4:
                    riskPercentage = thickIVHPresent ? 30 : 22
                case 5:
                    riskPercentage = thickIVHPresent ? 47 : 36
                default:
                    break
                }
            }
            
            
        } else if modifiedFisherScoreValue > 3 {
            // Right column
            
            if aged55OrOlder {
                // Upper right quadrant
                switch wfnsSahGradeValue {
                case 1:
                    riskPercentage = thickIVHPresent ? 27 : 19
                case 2, 3:
                    riskPercentage = thickIVHPresent ? 33 : 24
                case 4:
                    riskPercentage = thickIVHPresent ? 36 : 26
                case 5:
                    riskPercentage = thickIVHPresent ? 54 : 42
                default:
                    break
                }
                
            } else {
                // Lower right quadrant
                switch wfnsSahGradeValue {
                case 1:
                    riskPercentage = thickIVHPresent ? 33 : 24
                case 2, 3:
                    riskPercentage = thickIVHPresent ? 41 : 30
                case 4:
                    riskPercentage = thickIVHPresent ? 43 : 33
                case 5:
                    riskPercentage = thickIVHPresent ? 61 : 50
                default:
                    break
                }
            }
            
        }
        
        return riskPercentage
    }
    
    
    private func calculateBEHAVIORScore() -> Int {
        var score = 0
        let highFisherScore = fisherScore.calculateOriginalFisherScoreValue() >= 3 ? true : false
        let highHuntHessGrade = huntHessGrade.final >= 4 ? true : false
        
        score += earlyVasospasmOnDSA ? 3 : 0
        score += elevatedICP ? 3 : 0
        score += aged55OrOlder ? 1 : 0
        score += treatmentOfMultipleAneurysms ? 1 : 0
        score += highFisherScore ? 1 : 0
        score += highHuntHessGrade ? 1 : 0
        score += needForExternalVentricularShunt ? 1 : 0
        
        return score
    }
    
    
    private func calculateRiskPercentageAndConfidenceIntervalFromBEHAVIORScore() -> (riskPercentage: Double, confidenceInterval: String) {
        let behaviorScore = calculateBEHAVIORScore()
        var riskData = [5.6, 13.2, 36.6, 49.6, 57.1, 71.8, 84.5, 88.6, 100, 100, 100, 100]
        var confidenceIntervalData = ["1.5–18.1", "7.7–21.7", "28.6–45.4", "40.8–58.4", "46.0–67.6", "56.2–83.5", "74.4–91.1", "76.0–95.1", "70.1–100.0", "80.6–100.0", "51.0–100.0", "20.7–100.0"]
        
        if behaviorScore < 0 {
            return (-1, "No valid risk percentage can be calculated.")
        } else {
            let riskPercentage = riskData[behaviorScore]
            let confidenceInterval = confidenceIntervalData[behaviorScore]
            return (riskPercentage, confidenceInterval)
        }
    }
    
    
    // MARK:- Display risk info
    
    
    func displayRiskPercentageFromRiskChart() -> String {
        let riskPercentage = calculateRiskPercentageFromRiskChart()
        
        if riskPercentage < 0 {
            return "No valid risk percentage can be calculated."
        } else {
            return "Risk percentage DCI: \(riskPercentage)%."
        }
    }
    
    
    func displayRiskFromBEHAVIORScore() -> String {
        let riskPercentage = calculateRiskPercentageAndConfidenceIntervalFromBEHAVIORScore().riskPercentage
        let confidenceInterval = calculateRiskPercentageAndConfidenceIntervalFromBEHAVIORScore().confidenceInterval
        
        return "Risk percentage cerebral infarction: \(riskPercentage) (95% CI: \(confidenceInterval))"
    }
    
    
    func displayRisksForDelayedCerebralIschemia() -> String {
        
        let modifiedFisherScoreValue = fisherScore.calculateModifiedFisherScoreValue()
        let vasograde = VASOGRADE(wfnsSAHGrade: wfnsSahGrade, modifiedFisherScore: fisherScore.calculateModifiedFisherScore())
        let behaviorScore = calculateBEHAVIORScore()

        if selectionOfComponentsIsComplete {
        
            return "<body style=\"font-family: Arial; \"> " +
                "Risks for delayed cerebral ischemia (DCI) after SAH according to different grading systems." +
        
                    "<h3>BEHAVIOR Score</h3>" +
                    "<ul>" +
                    "<li>Score: \(behaviorScore)</li>" +
                    "<li>\(displayRiskFromBEHAVIORScore())</li>" +
                    "</ul>" +
        
                    "<h3>VASOGRADE</h3>" +
                    "<ul>" +
                    "<li>Grade: \(vasograde.final)</li>" +
                    "<li>Odds ratio DCI: \(vasograde.riskForDelayedCerebralIschemia().oddsRatio)</li>" +
                    "</ul>" +
        
                    "<h3>Risk Chart (from De Rooij, et al.)</h3>" +
                    "<ul>" +
                    "<li>\(displayRiskPercentageFromRiskChart())</li>" +
                    "</ul>" +
        
                    "<h3>Modified Fisher</h3>" +
                    "<ul>" +
                    "<li>Score: \(modifiedFisherScoreValue)</li>" +
                    "<li>Odds ratio vasospasm: \(ModifiedFisher.oddsRatioForSymptomaticVasospasm(modifiedFisherScoreValue))</li>" +
                    "</ul>" +
        
                    "<h3>Hunt &amp; Hess grade</h3>" +
                    "<ul>" +
                    "<li>Grade: \(huntHessGrade.final)</li>" +
                    "<li>Survival percentage: \(huntHessGrade.survivalPercentage)%</li>" +
                    "</ul>" +
        
                    "<h3>WFNS SAH Grade</h3>" +
                    "<ul>" +
                    "<li>Grade: \(wfnsSahGrade.final)</li>" +
                    "</ul>" +
                    
                    "<h3>Original Fisher</h3>" +
                    "<ul>" +
                    "<li>Score: \(fisherScore.calculateOriginalFisherScoreValue())</li>" +
                    "</ul>" +
                
            "</body>"
            
        } else {
            
            return "<body style=\"font-family: Arial; \"> " +
                "<h3>Not all required components have been selected</h3>" +
                "<h4>(please go back to previous screen)</h4>" +
            "</body>"
        }
        
    }

    
}
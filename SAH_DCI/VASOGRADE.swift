//
//  VASOGRADE
//
//  Required classes: ModifiedFisher, WfnsSAH
//
//  Reference:
//  De Oliveira Manoel, a. L., Jaja, B. N., Germans, M. R., Yan, H., Qian, W., Kouzmina, E., … Tseng, M.-Y. (2015). 
//  The VASOGRADE: A Simple Grading Scale for Prediction of Delayed Cerebral Ischemia After Subarachnoid Hemorrhage. 
//  Stroke, 1–7. http://doi.org/10.1161/STROKEAHA.115.008728
//
//  Created by Pieter Kubben on 21-08-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import Foundation

class VASOGRADE {
    
    // MARK:- Variables
    
    enum GradeColor: String {
        case SelectionIncomplete = "Selection of components is incomplete"
        case Green = "Green"
        case Yellow = "Yellow"
        case Red = "Red"
    }
    
    static let sections = WfnsSAH.sections + ModifiedFisher.sections
    static let items = WfnsSAH.items + ModifiedFisher.items
    
    var wfnsSAHGrade: WfnsSAH
    //var wfnsSAHGradeValue: Int
    var modifiedFisherScore: ModifiedFisher
    //var modifiedFisherScoreValue: Int
    var selectedCellIndices: [Int]
    
    var final: String {
        get {
            return calculateGradeColor()
        }
    }
    
    
    // MARK:- Methods
    
    
    init(wfnsSAHGrade: WfnsSAH = WfnsSAH(), modifiedFisherScore: ModifiedFisher = ModifiedFisher() ) {
        self.wfnsSAHGrade = wfnsSAHGrade
        self.modifiedFisherScore = modifiedFisherScore
        
        //self.wfnsSAHGradeValue = wfnsSAHGrade.final
        //self.modifiedFisherScoreValue = modifiedFisherScore.final
        
        self.selectedCellIndices = []
        for _ in VASOGRADE.sections {
            selectedCellIndices.append(-1)
        }
    }
    
    
    private func calculateGradeColor() -> String {
        
        let wfnsSAHGradeValue = wfnsSAHGrade.final
        let modifiedFisherScoreValue = modifiedFisherScore.final
        var gradeColor: String
        
        if wfnsSAHGradeValue < 0 || modifiedFisherScoreValue < 0 {
            // Selection is incomplete
            gradeColor = GradeColor.SelectionIncomplete.rawValue
            
        } else if wfnsSAHGradeValue <= 2 && modifiedFisherScoreValue <= 2 {
            // Green color
            gradeColor = GradeColor.Green.rawValue
            
        } else if wfnsSAHGradeValue <= 3 && (modifiedFisherScoreValue == 3 || modifiedFisherScoreValue == 4) {
            // Yellow color
            gradeColor = GradeColor.Yellow.rawValue
            
        } else if wfnsSAHGradeValue == 4 || wfnsSAHGradeValue == 5 {
            // Red color
            gradeColor = GradeColor.Red.rawValue
            
        } else {
            // Not captured in VASOGRADE
            gradeColor = "There is no VASOGRADE color associated with this combination."
        }
        
        return gradeColor
    }
    
    
    func riskForDelayedCerebralIschemia() -> (oddsRatio: String, validResult: Bool) {
        var oddsRatio = ""
        var validResult = true
        
        switch final {
        case GradeColor.Green.rawValue:
            oddsRatio = "1"
        case GradeColor.Yellow.rawValue:
            oddsRatio = "1.31 (95% CI 0.77 - 2.23)"
        case GradeColor.Red.rawValue:
            oddsRatio = "3.19 (95% CI 2.07 - 4.50)"
        case GradeColor.SelectionIncomplete.rawValue:
            oddsRatio = final + "."
            validResult = false
        default:
            oddsRatio = "No recommendation can be made based on this input."
            validResult = false
        }
        
        return (oddsRatio, validResult)
    }
    
    
    func displayRisksForDelayedCerebralIschemia() -> String {
        let wfnsSAHGradeValue = wfnsSAHGrade.final
        let modifiedFisherScoreValue = modifiedFisherScore.final
        let oddsRatioText = riskForDelayedCerebralIschemia().oddsRatio
        let showComponents = riskForDelayedCerebralIschemia().validResult
        
        if showComponents {
            return "<body style=\"font-family: Arial; \"> " +
            "Risks for delayed cerebral ischemia (DCI) after SAH according to different grading systems." +
                
                "<h3>VASOGRADE</h3>" +
                "<ul>" +
                    "<li>Grade: \(final)</li>" +
                    "<li>Odds ratio DCI: \(oddsRatioText)</li>" +
                "</ul>" +
                
                "<h3>Modified Fisher</h3>" +
                    "<ul>" +
                    "<li>Score: \(modifiedFisherScoreValue)</li>" +
                    "<li>Odds ratio vasospasm: \(ModifiedFisher.oddsRatioForSymptomaticVasospasm(modifiedFisherScoreValue))</li>" +
                "</ul>" +
                
                "<h3>WFNS SAH Grade</h3>" +
                "<ul>" +
                    "<li>Grade: \(wfnsSAHGradeValue)</li>" +
                "</ul>" +
                
            "</body>"
        } else {
            return "<body style=\"font-family: Arial; \"> " +
            "<h3>\(oddsRatioText)</h3>" +
            "<h4>(please go back to previous screen)</h4>" +
            "</body>"
        }
        
    }
    
}
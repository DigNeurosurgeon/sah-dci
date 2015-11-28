//
//  TableViewControllerAdvanced.swift
//  
//
//  Created by Pieter Kubben on 09-07-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class TableViewControllerAdvanced: UITableViewController {
    
    @IBOutlet weak var statusBarButton: UIBarButtonItem!
    
    var componentGCS = WfnsSAH.GCS.Unselected
    var componentDeficit = WfnsSAH.MotorDeficit.Unselected
    var componentSAH = Fisher.SAH.Unselected
    var componentIVH = Fisher.IVH.Unselected
    var componentAge = Advanced.Age.Unselected
    var componentEarlyVasospasm = Advanced.EarlyVasospasmOnDSA.Unselected
    var componentICP = Advanced.IntracranialPressure.Unselected
    var componentMultipleAneurysms = Advanced.TreatmentOfMultipleAneurysms.Unselected
    var componentHuntHessGrading = HuntHess.Grading.Unselected
    var componentExternalShunt = Advanced.NeedForExternalVentricularShunt.Unselected
    
    var score = Advanced()
    let sections = Advanced.sections
    let items = Advanced.items
    var selectedCellIndices = [Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCellIndices = score.selectedCellIndices
        
        _ = IRIS(version: "1.0", statusURLString: "http://dign.eu/apps/sah_dci/sah_dci_advanced.json", expirationTimeInDays: 30, eulaURLString: "http://dign.eu/eula", barButtonForStatusMessage: statusBarButton)

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }


    // MARK: - Table view data source

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return sections.count
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items[section].count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = items[indexPath.section][indexPath.row]
        
        if selectedCellIndices[indexPath.section] == indexPath.row {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let currentSection = indexPath.section
        let currentRow = indexPath.row

        // Uncheck previously selected cell
        if selectedCellIndices[currentSection] != currentRow {
            let oldRow = selectedCellIndices[currentSection]
            let oldPath = NSIndexPath(forRow: oldRow, inSection: currentSection)
            let oldCell = tableView.cellForRowAtIndexPath(oldPath)
            oldCell?.accessoryType = .None
            
            selectedCellIndices[currentSection] = currentRow
        }
        
        // Check selected cell
        if cell!.accessoryType == UITableViewCellAccessoryType.None {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        } 
        
        // Save corresponding value to score
        let selectedLabelText = cell!.textLabel?.text
        
        switch (currentSection) {
        case 0:
            componentGCS = WfnsSAH.GCS(rawValue: selectedLabelText!)!
        case 1:
            componentDeficit = WfnsSAH.MotorDeficit(rawValue: selectedLabelText!)!
        case 2:
            componentSAH = Fisher.SAH(rawValue: selectedLabelText!)!
        case 3:
            componentIVH = Fisher.IVH(rawValue: selectedLabelText!)!
        case 4:
            componentAge = Advanced.Age(rawValue: selectedLabelText!)!
        case 5:
            componentEarlyVasospasm = Advanced.EarlyVasospasmOnDSA(rawValue: selectedLabelText!)!
        case 6:
            componentICP = Advanced.IntracranialPressure(rawValue: selectedLabelText!)!
        case 7:
            componentMultipleAneurysms = Advanced.TreatmentOfMultipleAneurysms(rawValue: selectedLabelText!)!
        case 8:
            componentHuntHessGrading = HuntHess.Grading(rawValue: selectedLabelText!)!
        case 9:
            componentExternalShunt = Advanced.NeedForExternalVentricularShunt(rawValue: selectedLabelText!)!
        default:
            print("An error occurred when assigning a value to the scoring system.")
        }

        let componentFisherScore = Fisher(sah: componentSAH, ivh: componentIVH)
        let componentWfnsSAHGrade = WfnsSAH(gcs: componentGCS, motorDeficit: componentDeficit)
        let componentHuntHess = HuntHess(grading: componentHuntHessGrading)
        
        score = Advanced(wfnsSahGrade: componentWfnsSAHGrade, fisherScore: componentFisherScore, age: componentAge, vasospasm: componentEarlyVasospasm, icp: componentICP, multipleAneurysms: componentMultipleAneurysms, huntHessGrade: componentHuntHess, evs: componentExternalShunt)
        
    }
    
    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        enum SegueIdentifier: String {
            case Results = "AdvancedResults"
        }
        
        if segue.identifier == SegueIdentifier.Results.rawValue {
            let resultsViewController = segue.destinationViewController as! ResultsViewControllerAdvanced
            resultsViewController.score = score
        }
    }
    

}

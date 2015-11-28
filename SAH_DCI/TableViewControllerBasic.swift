//
//  TableViewControllerAdvanced.swift
//  
//
//  Created by Pieter Kubben on 09-07-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class TableViewControllerBasic: UITableViewController {
    
    @IBOutlet weak var statusBarButton: UIBarButtonItem!
    
    var componentGCS = WfnsSAH.GCS.Unselected
    var componentDeficit = WfnsSAH.MotorDeficit.Unselected
    var componentSAH = ModifiedFisher.SAH.Unselected
    var componentIVH = ModifiedFisher.IVH.Unselected
    
    var score = VASOGRADE()
    let sections = VASOGRADE.sections
    let items = VASOGRADE.items
    var selectedCellIndices = [Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCellIndices = score.selectedCellIndices
        
        _ = IRIS(version: "1.0", statusURLString: "http://dign.eu/apps/sah_dci/sah_dci_basic.json", expirationTimeInDays: 30, eulaURLString: "http://dign.eu/eula", barButtonForStatusMessage: statusBarButton)

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
        if cell?.accessoryType == UITableViewCellAccessoryType.None {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        } 
        
        // Save corresponding value to score
        let selectedLabelText = cell?.textLabel?.text
        
        switch (currentSection) {
            case 0:
                componentGCS = WfnsSAH.GCS(rawValue: selectedLabelText!)!
            case 1:
                componentDeficit = WfnsSAH.MotorDeficit(rawValue: selectedLabelText!)!
            case 2:
                componentSAH = ModifiedFisher.SAH(rawValue: selectedLabelText!)!
            case 3:
                componentIVH = ModifiedFisher.IVH(rawValue: selectedLabelText!)!
            default:
                print("An error occurred when assigning a value to the scoring system.")
        }
        
        let wfnsSAHGrade = WfnsSAH(gcs: componentGCS, motorDeficit: componentDeficit)
        let modifiedFisherScore = ModifiedFisher(sah: componentSAH, ivh: componentIVH)
        
        score = VASOGRADE(wfnsSAHGrade: wfnsSAHGrade, modifiedFisherScore: modifiedFisherScore)
        
    }
    
    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        enum SegueIdentifier: String {
            case Results = "BasicResults"
        }
        
        if segue.identifier == SegueIdentifier.Results.rawValue {
            let resultsViewController = segue.destinationViewController as! ResultsViewControllerBasic
            resultsViewController.score = score
        }
    }
    

}

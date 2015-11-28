//
//  ResultsViewController.swift
//  
//
//  Created by Pieter Kubben on 17-07-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
import MessageUI

class ResultsViewControllerAdvanced: UIViewController, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    var score = Advanced()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = score.displayRisksForDelayedCerebralIschemia()
        webView.loadHTMLString(output, baseURL: nil)
        
    }
    
    
    @IBAction func exportButtonTapped(sender: AnyObject) {
        createEmailMessageWithReport()
    }
    
    
    // MARK:- Email export
    
    
    func createEmailMessageWithReport() {
        let modifiedFisherScore = score.fisherScore.calculateModifiedFisherScore()
        
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setSubject("SAH DCI advanced results report")
        
        let messageBodyText = "<p><em>Note: this email will be sent unencrypted and data privacy cannot be guaranteed, just as with any other email message. Be aware of privacy issues and do not provide patient identification details.</em></p>" +
            
            "If you think there is an error in this app, please send a message (or cc this email) to " +
            "<a href=\"mailto:support@digitalneurosurgeon.com\">support@digitalneurosurgeon.com</a>." +
        
            "<p>Optional comments:</p>" +
            
            "<h2><u>Input parameters</u></h2>" +
            
            "<li>Glasgow Coma Scale: " + score.wfnsSahGrade.gcs.rawValue + "</li>" +
            "<li>Motor deficit: " + score.wfnsSahGrade.motorDeficit.rawValue + "</li>" +
            "<li>Subarachnoid hemorrhage: " + modifiedFisherScore.sah.rawValue + "</li>" +
            "<li>Intraventricular hemorrhage: " + modifiedFisherScore.ivh.rawValue + "</li>" +
            "<li>Age: " + score.age.rawValue + "</li>" +
            "<li>Early vasospasm on DSA: " + score.vasospasm.rawValue + "</li>" +
            "<li>Intracranial pressure: " + score.icp.rawValue + "</li>" +
            "<li>Treatment of multiple aneurysms: " + score.multipleAneurysms.rawValue + "</li>" +
            "<li>Hunt &amp; Hess grade: " + score.huntHessGrade.grading.rawValue + "</li>" +
            "<li>Need for external ventricular shunt: " + score.evs.rawValue + "</li>" +
            
            "<h2><u>Advanced results</u></h2>" +
            score.displayRisksForDelayedCerebralIschemia()
        
        email.setMessageBody(messageBodyText, isHTML: true)
        
        // Save for later file addition (possibly CSV with decision support parameters)
        // let csvData = NSData(contentsOfFile: csvFilePath)
        // email.addAttachmentData(csvData, mimeType: "text/csv", fileName: csvFileName)
        
        presentViewController(email, animated: true, completion: nil)
        
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}

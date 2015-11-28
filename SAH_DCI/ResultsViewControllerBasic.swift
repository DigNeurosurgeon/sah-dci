//
//  ResultsViewController.swift
//  
//
//  Created by Pieter Kubben on 17-07-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
import MessageUI

class ResultsViewControllerBasic: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var score = VASOGRADE()
    
    
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
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self
        email.setSubject("SAH DCI basic results report")
        
        let messageBodyText = "<p><em>Note: this email will be sent unencrypted and data privacy cannot be guaranteed, just as with any other email message. Be aware of privacy issues and do not provide patient identification details.</em></p>" +
            
            "If you think there is an error in this app, please send a message (or cc this email) to " +
            "<a href=\"mailto:support@digitalneurosurgeon.com\">support@digitalneurosurgeon.com</a>." +
            
            "<p>Optional comments:</p>" +
        
            "<h2><u>Input parameters</u></h2>" +
            
            "<li>Glasgow Coma Scale: " + score.wfnsSAHGrade.gcs.rawValue + "</li>" +
            "<li>Motor deficit: " + score.wfnsSAHGrade.motorDeficit.rawValue + "</li>" +
            "<li>Subarachnoid hemorrhage: " + score.modifiedFisherScore.sah.rawValue + "</li>" +
            "<li>Intraventricular hemorrhage: " + score.modifiedFisherScore.ivh.rawValue + "</li>" +
            
            "<h2><u>Basic results</u></h2>" +
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

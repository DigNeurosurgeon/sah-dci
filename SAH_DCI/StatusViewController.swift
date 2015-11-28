//
//  StatusViewController.swift
//  
//
//  Created by Pieter Kubben on 17-05-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IRIS.loadStatusContentInWebView(webView)
    }

}

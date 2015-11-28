//
//  InfoViewController.swift
//  
//
//  Created by Pieter Kubben on 17-05-15.
//  Copyright (c) 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IRIS.loadInfoContentInWebview("http://dign.eu/apps/vasograde", webView: webView)
    }


}

//
//  WebViewController.swift
//  adopteUnDev
//
//  Created by Badr Choukri on 15/08/2018.
//  Copyright © 2018 Badr Choukri. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    var urlGithub = "https://github.com/"
    override func viewDidLoad() {
        super.viewDidLoad()
        let githubRequest = URLRequest(url: URL(string: urlGithub)!)
        webView.load(githubRequest)
    }

}

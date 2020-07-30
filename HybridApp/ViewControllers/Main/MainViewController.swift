//
//  MainViewController.swift
//  HybridApp
//
//  Created by Kim-D on 2020. 7. 7..
//  Copyright © 2020년 Kim-D. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var wkWebView: CustomWKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.wkWebView.setWKWebViewAction { (webViewAction, result) in
            switch webViewAction {
                case .DidStartProvisionalNavigation:
                    print("=== WebView load Start!!!!")
                    break
                case .DidFinishNavigation:
                    print("=== WebView load Finish!!!!")
                    break
                case .DidFailNavigation:
                    print("=== WebView load Fail!!!!" + (result as! Error).localizedDescription)
                    break
                default:
                    break;
            }
        }
        self.wkWebView.loadUrl(url: "http://xxx.xxx.xxx.xxx:3000")
        //perform(#selector(openGigagenieApp), with: nil, afterDelay: 3.0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func openApp() {
        UIApplication.shared.open(URL(string:"")!, options: [:]) { (ret) in
            if (ret) {
                print("====== app open!!!!");
            } else {
                print("====== app open fail!!!");
            }
        }
    }

}


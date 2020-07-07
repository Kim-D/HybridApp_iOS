//
//  MainViewController.swift
//  HybridApp
//
//  Created by KT on 2020. 7. 7..
//  Copyright © 2020년 Kimd. All rights reserved.
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
            }
        }
        self.wkWebView.loadUrl(url: "https://www.naver.com")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


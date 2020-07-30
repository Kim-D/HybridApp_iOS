//
//  FullPopupViewController.swift
//  HybridApp
//
//  Created by Kim-D on 2020. 7. 20..
//  Copyright © 2020년 Kim-D. All rights reserved.
//

import UIKit

protocol FullPopupViewDelegate: NSObjectProtocol {
    //WebPage 에서 전달 받은 메시지를 처리할 func 를 정의
    func closeFullPopup(code: String?)
}

class FullPopupViewController: UIViewController {
    @IBOutlet weak var topGuideViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleViewTitle: UILabel!
    @IBOutlet weak var titleBackButton: UIButton!
    
    @IBOutlet weak var wkWebView: CustomWKWebView!
    weak var delegate: FullPopupViewDelegate?
    
    var popupTitle: String? = nil
    var loadUrl: String? = nil
    var hookingUrl: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initFullPoupView()
    }
    
    override func viewDidLayoutSubviews() {
        self.topGuideViewHeight.constant = self.topLayoutGuide.length
        if (self.popupTitle == nil) {
            self.titleViewHeight.constant = 0.0
            self.titleBackButton.isHidden = true
        }
        self.view.updateConstraints()
    }
    
    @IBAction func onButtonClick(sender: Any?) {
        let button = sender as! UIButton
        switch (button.tag) {
            case 0:
                self.navigationController?.popViewController(animated: true)
                break;
            default:
                break;
        }
    }
    
    func initFullPoupView() {
        if (self.popupTitle != nil) {
            self.titleViewTitle.text = self.popupTitle
        }
        
        if (self.loadUrl != nil) {
            self.wkWebView.setWKWebViewAction { (webViewAction, result) in
                switch (webViewAction) {
                    case .DecidePolicyFor:
                        //redirect url - result
                        let redirectUrl = result as! String
                        print("======== get redirectUrl - ", redirectUrl)
                        if let hookingUrl = self.hookingUrl {
                            if (redirectUrl != self.loadUrl! && redirectUrl.contains(hookingUrl)) {
                                let array = redirectUrl.split(separator: "?")
                                if (array.count > 1) {
                                    let urlParam = String(array[1])
                                    let params = urlParam.split(separator: "&")
                                    for param in params {
                                        if (param.contains("code")) {
                                            let array = param.split(separator: "=")
                                            if (array.count > 1) {
                                                let code = String(array[1])
                                                self.perform(#selector(self.runDelegteCloseFullPopup(code:)), with: code, afterDelay: 0.5);
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        break
                    default:
                        break
                }
            }
            perform(#selector(popupViewLoadUrl), with: nil, afterDelay: 0.7);
        }
    }
    
    @objc func popupViewLoadUrl() {
        self.wkWebView.loadUrl(url: self.loadUrl!)
    }
    
    @objc func runDelegteCloseFullPopup(code: String?) {
        self.delegate?.closeFullPopup(code: code)
    }
}

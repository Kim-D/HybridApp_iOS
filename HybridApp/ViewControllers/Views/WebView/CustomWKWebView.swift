//
//  CustomWKWebView.swift
//  HybridApp
//
//  Created by KT on 2020. 7. 7..
//  Copyright © 2020년 Kimd. All rights reserved.
//

import Foundation
import UIKit
import WebKit

enum WKWebViewAction: Int {
    case DidFinishNavigation
    case DidStartProvisionalNavigation
    case DidFailNavigation
}

typealias WKWebViewActionHandler = (WKWebViewAction, Any?) -> Void

class CustomWKWebView: UIView, WKNavigationDelegate, WKUIDelegate, ScriptMessageHandlerDelegate {
    var wkWebView: WKWebView!
    var scriptMessageHandler: ScriptMessageHandler!
    var actionHandler: WKWebViewActionHandler!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scriptMessageHandler = ScriptMessageHandler()
        self.scriptMessageHandler.delegate = self
        self.initWKWebView(frame: frame, configuration: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.scriptMessageHandler = ScriptMessageHandler()
        self.scriptMessageHandler.delegate = self
        self.initWKWebView(frame: frame, configuration: nil)
    }
    
    convenience init(frame: CGRect, configuration: WKWebViewConfiguration) {
        self.init(frame: frame)
    }
    
    func initWKWebView(frame: CGRect, configuration: WKWebViewConfiguration?) {
        let configuration = (configuration == nil) ? self.getWKWebViewConfigration() : configuration
        self.wkWebView = WKWebView(frame: frame, configuration: configuration!)
        
        self.wkWebView.translatesAutoresizingMaskIntoConstraints = false
        self.wkWebView.scrollView.bounces = true
        self.wkWebView.scrollView.showsHorizontalScrollIndicator = false
        self.wkWebView.navigationDelegate = self
        self.wkWebView.uiDelegate = self
        self.wkWebView.scrollView.scrollsToTop = true
        
        self.wkWebView.backgroundColor = UIColor.white
        
        self.addSubview(self.wkWebView)
        //set autolayout
        self.addWKWebViewConstraint(attribute: NSLayoutAttribute.top)
        self.addWKWebViewConstraint(attribute: NSLayoutAttribute.leading)
        self.addWKWebViewConstraint(attribute: NSLayoutAttribute.trailing)
        self.addWKWebViewConstraint(attribute: NSLayoutAttribute.bottom)
    }
    
    func getWKWebViewConfigration() -> WKWebViewConfiguration {
        let wkWebViewConfiguration = WKWebViewConfiguration()
        let kuserContentController = WKUserContentController()
        let kwebviewPreference = WKPreferences()
        
        //Message 핸들러 설정
        kuserContentController.add(self.scriptMessageHandler, name: "bridge")
        wkWebViewConfiguration.userContentController = kuserContentController
        
        // 메모리에서 랜더링 후 보여줌 Defalt = false
        // true 일경우 랜더링 시간동안 Black 스크린이 나옴
        wkWebViewConfiguration.suppressesIncrementalRendering = false
        
        // 기본값 : Dynamic (텍스트 선택시 정밀도 설정)
        wkWebViewConfiguration.selectionGranularity = WKSelectionGranularity.dynamic
        
        // 기본값 false : HTML5 Video 형태로 플레이
        // true  : native full-screen play
        wkWebViewConfiguration.allowsInlineMediaPlayback = false
        
        // 기본값 : true
        // true : 사용자가 시작 , false : 자동시작
        wkWebViewConfiguration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes.all
        
        // WKPreference 셋팅
        kwebviewPreference.minimumFontSize = 0                                  // 기본값 = 0
        kwebviewPreference.javaScriptCanOpenWindowsAutomatically = true         // 기본값 = false
        kwebviewPreference.javaScriptEnabled = true                             // 기본값 = true
        
        wkWebViewConfiguration.preferences = kwebviewPreference;
        
        return wkWebViewConfiguration
    }
    
    func addWKWebViewConstraint(attribute: NSLayoutAttribute) {
        self.addConstraint(NSLayoutConstraint(item: self.wkWebView, attribute: attribute, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: attribute, multiplier: 1.0, constant: 0.0))
    }
    
    func loadUrl(url: String) {
        let request = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 20.0)
        request.httpMethod = "POST"
        self.wkWebView.load(request as URLRequest)
    }
    
    func setWKWebViewAction(actionHandler: WKWebViewActionHandler?){
        if let handler = actionHandler {
            self.actionHandler = handler
        }
    }
    
    func executeJavascript(javascript: String) {
        self.wkWebView.evaluateJavaScript(javascript) { (result, error) in
            
        }
    }
    
    func getWKWebView() -> WKWebView {
        return self.wkWebView
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let handler = self.actionHandler {
            handler(WKWebViewAction.DidStartProvisionalNavigation, nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let handler = self.actionHandler {
            handler(WKWebViewAction.DidFinishNavigation, nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if let handler = self.actionHandler {
            handler(WKWebViewAction.DidFailNavigation, error)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    //url redirect
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("==== redirect url - " + (navigationAction.request.url?.absoluteString)!)
        
        switch navigationAction.navigationType {
        case WKNavigationType.linkActivated:
            //tel, sms, mailto 처리 가능
            break
        default:
            break
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    /*
     * 웹에서 오픈윈도우를 실행 했을 때 호출되는 delegate
     */
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let childWebView = CustomWKWebView(frame: CGRect(x: 0.0, y: 100.0, width: 100.0, height: 100.0), configuration: configuration)
        //Window open 후 close 시킬 자바 스크립트 추가
        let script = "var originalWindowClose=window.close;window.close=function(){var iframe=document.createElement('IFRAME');iframe.setAttribute('src','bridge://window_close'),document.documentElement.appendChild(iframe);originalWindowClose.call(window)};"
        let userScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        childWebView.getWKWebView().configuration.userContentController.addUserScript(userScript)
        
        return childWebView.getWKWebView()
    }
    
    //확인 팝업 필요할 때 호출
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
}

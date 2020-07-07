//
//  ScriptMessageHandler.swift
//  HybridApp
//
//  Created by KT on 2020. 7. 7..
//  Copyright © 2020년 Kimd. All rights reserved.
//

import Foundation
import WebKit


/*
 
 Web 에서 WKWebView 에 메시지 전달
 
 var message = {
 'action': 'bind',
 'name': 'message'
 }; -> key : value 형식이여서 Dictionary 형태로 전달 됨
 
 window.webkit.messageHandlers.bridge.postMessage(message);
 
 */

protocol ScriptMessageHandlerDelegate: NSObjectProtocol {
    //WebPage 에서 전달 받은 메시지를 처리할 func 를 정의
}

class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: ScriptMessageHandlerDelegate?
    
    override init() {
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //message.body 로 전달 되는 객체를 사용 한다
    }
}

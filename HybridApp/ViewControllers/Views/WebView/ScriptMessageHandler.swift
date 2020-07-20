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
    func openFullPopup(param: NSDictionary?, callback: String?)
}

class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: ScriptMessageHandlerDelegate?
    
    override init() {
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //message.body 로 전달 되는 객체를 사용 한다
        print("======= message name -", message.name)
        print("======= message body -", message.body)
        let action: String?
        let param: NSDictionary?
        let callback: String?
        
        if (message.body is NSDictionary) {
            action = (message.body as! NSDictionary).object(forKey: "action") as? String
            param = (message.body as! NSDictionary).object(forKey: "param") as? NSDictionary
            callback = (message.body as! NSDictionary).object(forKey: "callback") as? String
            if (action == "open_fullpopup") {
                print("======= called action -", action!)
                self.delegate?.openFullPopup(param: param, callback: callback)
            }
        }
    }
}

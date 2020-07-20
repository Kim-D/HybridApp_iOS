//
//  Util.swift
//  HybridApp
//
//  Created by KT on 2020. 7. 20..
//  Copyright © 2020년 Kimd. All rights reserved.
//

import Foundation
import UIKit

typealias DefaultHandler = () -> Void

class Util : NSObject {
    
    // 싱글톤 객체는 static let을 통해 만든다
    static let sharedInstance = Util()
    
    func getTopViewController(isChildCheck: Bool) -> UIViewController! {
        var topView = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).viewControllers.last!
        //var topView = viewControllers[]
        print("====== viewControllers  - ", topView)
        
        if (isChildCheck) {
            if ((topView.childViewControllers.count) > 0) {
                topView = topView.childViewControllers.last!
            }
            
            var modalView = topView.presentedViewController
            while (modalView?.presentedViewController != nil) {
                modalView = modalView?.presentedViewController
            }
            
            if let modal = modalView {
                topView = modal
            }
        }
        
        return topView
    }

    func showConfirmAlertWithTitle(title: String?, message: String?, handler: DefaultHandler?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let confirm = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel) { (action) in
            if let defaultHandler = handler {
                defaultHandler()
            }
        }
        alertController.addAction(confirm)
        (self.getTopViewController(isChildCheck: false)).present(alertController, animated: true, completion: nil)
    }
}

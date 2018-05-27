//
//  Alert.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/27.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class Alert {
    // アラートを表示するメソッド（ボタン2個）
    public static func presentTwoBtnAlert(vc: UIViewController, title: String, message: String, positiveTitle: String, negativeTitle: String, positiveAction: @escaping () -> Void) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.alert)
        
        let positiveAction: UIAlertAction = UIAlertAction(title: positiveTitle, style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            positiveAction()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: negativeTitle, style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(positiveAction)
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}

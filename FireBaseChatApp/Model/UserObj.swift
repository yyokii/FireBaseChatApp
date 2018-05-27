//
//  UserObj.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/26.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation
import UIKit

struct UserObj {
    
    var uid: String?
    var name: String?
    
    init(uid: String, userData: Dictionary<String, AnyObject>) {
        
        self.uid = uid
        if let name = userData["name"] as? String {
            self.name = name
        }
    }
}


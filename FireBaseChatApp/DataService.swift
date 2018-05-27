//
//  DataService.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/21.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

// FIXME: dbを参照する処理は極力少なくしたいから、ログインユーザー情報とかは構造体で持っといた方がいいかも
class DataService {
    
    static let ds = DataService()
    
    //DB referrence
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child(USER)
    private var _REF_TALK_ROOM = DB_BASE.child(TALK_ROOM)

    private var _REF_USER_IMAGES = STORAGE_BASE.child(USER)
    //アイコンupload用
    //private var _REF_USER_IMAGES = STORAGE_BASE.child(USER_ICON_PICS)
    
    var REF_BASE: DatabaseReference {
        
        return _REF_BASE
    }
    
    var REF_USER: DatabaseReference {
        
        return _REF_USER
    }
    
    var REF_TALK_ROOM: DatabaseReference {
        
        return _REF_TALK_ROOM
    }
    
    var REF_USER_IMAGES: StorageReference {
        
        return _REF_USER_IMAGES
    }
}

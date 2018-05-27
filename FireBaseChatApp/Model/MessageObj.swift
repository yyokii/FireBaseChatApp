//
//  MessageObj.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/20.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import Foundation
import MessageKit

struct MessageObj: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    // テキスト
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
}

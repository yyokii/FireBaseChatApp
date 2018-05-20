//
//  ViewController.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/19.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import MessageKit

class ViewController: MessagesViewController {
    
    // 表示するメッセージリスト
    var messageList: [MessageObj] = []
    
    // 日付変換用フォーマット
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    // チャット相手
    let partner = Sender(id: "123456", displayName: "Partner")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // サンプルデータを設定
        setSampleMessages()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
//        messagesCollectionView.messageCellDelegate = self
        
        // あとでもいいかな
        // messageInputBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // サンプルのメッセージデータ生成
    func setSampleMessages(){
        for i in 0..<10 {
            let uniqueID = NSUUID().uuidString
            
            var message: MessageObj!
            if ( i % 2 == 0 ){
                message = MessageObj(text: "hi: test:\(i)", sender: currentSender(), messageId: uniqueID, date: Date())
            }else {
                message = MessageObj(text: "hi: test:\(i)", sender: partner, messageId: uniqueID, date: Date())
            }
            messageList.append(message)
        }
    }
}

// メッセージデータの管理
extension ViewController: MessagesDataSource {
    
    // チャットの送信者 = ユーザー
    func currentSender() -> Sender {
        let me = Sender(id: "654321", displayName: "me")
        return me
    }
    
    // メッセージ数
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    //各メッセージの内容
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        // セクションごとでメッセージが区切られている
        return messageList[indexPath.section]
    }
    
    // 一番上部にくるテキスト。通常はnil。（例）日付を表示するのに使用される。
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    // メッセージの上部にくるテキスト。（例）名前
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    // メッセージの下部にくるテキスト。（例）日付
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// メッセージの見た目を設定する
extension ViewController: MessagesDisplayDelegate {
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    // メッセージ部分のスタイルを決める
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    // 各メッセージの送りての画像、アバターを設定する
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if(message.sender == partner){
            avatarView.set(avatar: Avatar(image: #imageLiteral(resourceName: "Steve-Jobs"), initials: "SJ"))
        }else {
            avatarView.set(avatar: Avatar(image: #imageLiteral(resourceName: "Tim-Cook"), initials: "TC"))
        }
    }
}

// サイズを設定
extension ViewController: MessagesLayoutDelegate {
    
    // 一番上部にくるテキストのビューサイズ。
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    // メッセージの上部にくるテキストのビューサイズ。
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    // メッセージの下部にくるテキストのビューサイズ。
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}

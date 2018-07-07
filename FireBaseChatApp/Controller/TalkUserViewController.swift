//
//  TalkUserViewController.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/06/05.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import Firebase

class TalkUserViewController: UIViewController {

    @IBOutlet weak var talkUserTableView: UITableView!
    var talkUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        talkUserTableView.delegate = self
        talkUserTableView.dataSource = self
        
        fetchTalkUser { (talkUsers) in
            self.talkUsers = talkUsers
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchTalkUser(completion:@escaping ([String]) -> Void){
        // FIXME: このユーザーIDの取得は散乱しているので、まとめてもいいかも
        let currentUserID = UserDefaults.standard.string(forKey: UID)!
        DataService.ds.REF_USER.child(currentUserID).child(TALK_ROOM).observeSingleEvent(of: .value) {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                var talkUsers = [String]()
                for snap in snapshot {
                    print("現在トーク中のユーザーのid：\(String(describing: snap.value))")
                    let talkingUserID = snap.value as! String
                    talkUsers.append(talkingUserID)
                }
                completion(talkUsers)
            }
        }
    }
}

extension TalkUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talkUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // FIXME: ここでユーザー情報を取得する
        
        return UITableViewCell()
    }
}

extension TalkUserViewController: UITableViewDelegate {
    
}

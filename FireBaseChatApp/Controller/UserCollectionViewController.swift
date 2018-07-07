//
//  UserCollectionViewController.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/22.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "userCell"

class UserCollectionViewController: UICollectionViewController {

    var users = [UserObj]()
    // FIXME: このユーザーIDの取得は散乱しているので、まとめてもいいかも
    let currentUserID = UserDefaults.standard.string(forKey: UID)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        fetchUsersData { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 全ユーザー情報を取得
    func fetchUsersData(completion: @escaping (() -> Void)) {
        DataService.ds.REF_USER.observeSingleEvent(of: .value) {[weak self] (snapshot) in
            // FIXME: ここ、[DataSnapshot]でいいかも
            if let snapshotValues = snapshot.value as? [String: [String: AnyObject]] {
                for snap in snapshotValues {
                    let userData = snap.value
                    let user = UserObj(uid: snap.key, userData: userData)
                    self?.users.insert(user, at: 0)
                }
                completion()
            }
        }
    }
    
    func talkAction (talkUserID: String, completion: @escaping (() -> Void)){
        let memberData = [currentUserID : true, talkUserID: true]
        
        checkTalkingUser(talkUserID: talkUserID) {
            DataService.ds.REF_TALK_ROOM.childByAutoId().updateChildValues(memberData) { [weak self] (error, ref) in
                print("作成されたroomのID：\(ref.key)")
                
                guard let currentUserID = self?.currentUserID else {
                    // FIXME: serIDの取得方法変えたこの処理消した方がいいかも、return場合に作成されたroom不要になる
                    return
                }
                
                // ユーザーのtalkRoomデータを作成
                let myRoomData = [ref.key:talkUserID]
                // トーク相手のtalkRoomデータを作成
                let talkUserData = [ref.key:currentUserID]
                
                let childUpdates = ["/\(USER)/\(currentUserID)/\(TALK_ROOM)": myRoomData,
                                    "/\(USER)/\(talkUserID)/\(TALK_ROOM)/": talkUserData]
                
                DataService.ds.REF_BASE.updateChildValues(childUpdates) { (error, ref) in
                    // トーク画面に遷移
                }
            }
        }
    }
    
    func checkTalkingUser(talkUserID: String, completion: @escaping (() -> Void)){
        DataService.ds.REF_USER.child(currentUserID).child(TALK_ROOM).observeSingleEvent(of: .value) {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                if snapshot.count == 0 {
                    print("初めてのトーク")
                    completion()
                }else {
                    for snap in snapshot {
                        print("現在トーク中のユーザーのid：\(String(describing: snap.value))")
                        let talkingUserID = snap.value as! String
                        if talkingUserID == talkUserID {
                            print("すでにトークルームが存在しています")
                            return
                        }else {
                            // ユーザーとトークするためのDB情報を作成する
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCollectionViewCell
        cell.nameLabel.text = users[indexPath.row].name
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedUserID = users[indexPath.row].uid else{
            return
        }
        
        if selectedUserID == currentUserID  {
            Alert.presentOneBtnAlert(vc: self, title: "おっと！\nその素敵な人はあなたです :)", message: "", positiveTitle: "CLOSE", positiveAction: {})
        }else {
            Alert.presentTwoBtnAlert(vc: self, title: "トークしましょう！", message: "\(users[indexPath.row].name ?? "このユーザー") とトークします", positiveTitle: "OK", negativeTitle: "CACEL") { [weak self] in
                self?.talkAction(talkUserID: selectedUserID, completion: {
                    print("tes")
                })
            }
        }
    }
}

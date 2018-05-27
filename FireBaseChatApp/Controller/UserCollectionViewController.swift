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
            DataService.ds.REF_TALK_ROOM.childByAutoId().updateChildValues(memberData) {(error, ref) in
                print("作成されたroomのID：\(ref.key)")
                
                // ユーザーの talkRoom を作成
                let talkRoomData = [ref.key:talkUserID]
                DataService.ds.REF_USER.child(self.currentUserID).child(TALK_ROOM).updateChildValues(talkRoomData) { (error, ref) in
                    // トーク画面に遷移
                }
            }
        }
    }
    
    func checkTalkingUser(talkUserID: String, completion: @escaping (() -> Void)){
        DataService.ds.REF_USER.child(currentUserID).child(TALK_ROOM).observeSingleEvent(of: .value) {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
        Alert.presentTwoBtnAlert(vc: self, title: "トークしましょう！", message: "\(users[indexPath.row].name ?? "このユーザー") とトークします", positiveTitle: "OK", negativeTitle: "CACEL") { [weak self] in
            self?.talkAction(talkUserID: (self?.users[indexPath.row].uid)!, completion: {
                print("tes")
            })
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

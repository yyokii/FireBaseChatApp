//
//  LoginViewController.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/21.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyImagePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyImagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        // ユーザーのプロフィール画像をタップしてカメラロールから変更できるようにする
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(imageTap)
    }
    
    @objc func imageTapped() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func LoginTapped(_ sender: Any) {
        guard nameTextField.text != "" , nameTextField.text != "" else {
            return
        }
        
        loginAnonymous(name: nameTextField.text!)
    }
    
    func loginAnonymous(name: String){
        //匿名アカウントを認証する
        Auth.auth().signInAnonymously() { [weak self] (result, error) in
            if error != nil {
                //エラー時の処理
                return
            }
            //成功時の処理、ユーザー情報追加
            let userData: Dictionary<String,Any> = ["name": name]
            self?.completeSignIn(id: (result?.user.uid)!, userData: userData)
        }
    }
    
    func completeSignIn (id: String, userData: Dictionary<String,Any>){
        DataService.ds.REF_USER.child(id).updateChildValues(userData) { [weak self] (error, ref) in
            
            UserDefaults.standard.set(id, forKey: UID)
            // 画面遷移
            //self?.performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    /// 画像をストレージにアップロードする
//    ///
//    /// - Parameters:
//    ///   - image: 保存する画像
//    static func uploadImage(image: UIImage, completion: @escaping (() -> Void)){
//        if let imgData = UIImageJPEGRepresentation(image, 0.5) {
//            let imgUid = KeychainWrapper.standard.string(forKey: KEY_UID)!
//            let matadata = FIRStorageMetadata()
//            matadata.contentType = "image/jpeg"
//
//            // 画像をfirebaseストレージに追加
//            DataService.ds.REF_USER_IMAGES.child(imgUid).put(imgData, metadata: matadata) { (metadata, error) in
//                if error != nil {
//                    print("Error: Firebasee storageへの画像アップロード失敗")
//                } else {
//                    print("OK:　Firebase storageへの画像アップロード成功")
//                    completion()
//                }
//            }
//        }
//    }
}

extension LoginViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImageView.image = image
        } else {
            print("Error: 画像が選択されませんでした")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

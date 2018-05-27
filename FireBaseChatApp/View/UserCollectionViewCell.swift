//
//  UserCollectionViewCell.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/05/22.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

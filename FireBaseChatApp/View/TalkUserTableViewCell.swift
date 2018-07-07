//
//  TalkUserTableViewCell.swift
//  FireBaseChatApp
//
//  Created by Yoki Higashihara on 2018/06/05.
//  Copyright © 2018年 Yoki Higashihara. All rights reserved.
//

import UIKit

class TalkUserTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

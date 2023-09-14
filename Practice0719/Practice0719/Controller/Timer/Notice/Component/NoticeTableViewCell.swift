//
//  NoticeTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/1.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    @IBOutlet weak var noticeLabel: UILabel!
    static let identifier = "NoticeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  MentionTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/27.
//

import UIKit

class MentionTableViewCell: UITableViewCell {
    @IBOutlet weak var MentionBellLabel: UILabel!
    
    static let identifier = "MentionTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

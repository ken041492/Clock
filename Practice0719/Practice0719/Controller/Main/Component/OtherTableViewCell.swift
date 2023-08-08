//
//  OtherTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/25.
//

import UIKit

class OtherTableViewCell: UITableViewCell {
    @IBOutlet weak var otherLabel: UILabel!
    static let identifier = "OtherTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

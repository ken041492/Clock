//
//  BRPTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/25.
//

import UIKit

class BRPTableViewCell: UITableViewCell {
    @IBOutlet weak var weekLabel: UILabel!
    static let identifier = "BRPTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

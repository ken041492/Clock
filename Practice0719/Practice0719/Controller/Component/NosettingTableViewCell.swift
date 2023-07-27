//
//  NosettingTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/25.
//

import UIKit

class NosettingTableViewCell: UITableViewCell {
    @IBOutlet weak var noalart: UILabel!
    @IBOutlet weak var setting: UIButton!
    static let identifier = "NosettingTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

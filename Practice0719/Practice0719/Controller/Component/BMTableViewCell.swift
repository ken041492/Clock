//
//  BMTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/24.
//

import UIKit

class BMTableViewCell: UITableViewCell {
    @IBOutlet weak var mentionLabel: UILabel!
    @IBOutlet weak var mentionSwitch: UISwitch!
    
    static let identified = "BMTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

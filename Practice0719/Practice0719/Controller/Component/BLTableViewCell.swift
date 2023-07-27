//
//  BLTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/24.
//

import UIKit

class BLTableViewCell: UITableViewCell {
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var WeekTextField: UITextField!
    
    static let identified = "BLTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

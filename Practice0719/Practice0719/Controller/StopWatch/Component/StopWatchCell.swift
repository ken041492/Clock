//
//  StopWatchCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/3.
//

import UIKit

class StopWatchCell: UITableViewCell {
    
    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var timerResultLabel: UILabel!
    
    static let identifier = "StopWatchCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

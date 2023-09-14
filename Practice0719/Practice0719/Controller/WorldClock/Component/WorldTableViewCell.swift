//
//  WorldTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/4.
//

import UIKit

class WorldTableViewCell: UITableViewCell {
    @IBOutlet weak var TimeGap: UILabel!
    @IBOutlet weak var AreaLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    
    static let identifier = "WorldTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

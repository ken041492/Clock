//
//  CityTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/4.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var CityLabel: UILabel!
    static let identifier = "CityTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  AlartTitleTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/25.
//

import UIKit

class AlartTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var Alart: UILabel!
    @IBOutlet weak var sleep: UILabel!
    static let identifier = "AlartTitleTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

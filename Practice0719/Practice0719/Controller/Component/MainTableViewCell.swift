//
//  MainTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var Period: UILabel!
    @IBOutlet weak var ClockTime: UILabel!
    @IBOutlet weak var NoticeBell: UISwitch!
    @IBOutlet weak var indicateWeek: UILabel!
    static let identified = "MainTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

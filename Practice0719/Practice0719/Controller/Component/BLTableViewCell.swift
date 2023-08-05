//
//  BLTableViewCell.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/24.
//

import UIKit

class BLTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var WeekTextField: UITextField!
    
    let userDefaults = UserDefaults.standard
    static let identified = "BLTableViewCell"
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = WeekTextField.text {
            // 將內容保存到 UserDefaults 中
            userDefaults.set(text, forKey: "SavedText")
            userDefaults.synchronize() // 可選的，用於立即寫入 UserDefaults
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        WeekTextField.delegate = self 
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

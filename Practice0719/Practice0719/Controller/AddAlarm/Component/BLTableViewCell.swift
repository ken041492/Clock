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
    var register: String = ""
    
    @IBAction func input(_ sender: UITextField) {
    }
    
    
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
        WeekTextField.clearButtonMode = .whileEditing
//        WeekTextField.addTarget(self, action: #selector(BLTableViewCell.textFieldDidChange(_:)), for: .editingChanged)
//        WeekTextField.text = "鬧鐘"
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if let newText = textField.text {
//            print("\(newText)")
//            register = newText
//        }
//        BViewController().test = register
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 在这里可以监听文本变化，进行相关处理

        return true
    }
}

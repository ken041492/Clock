//
//  MentionViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/24.
//

import UIKit

class MentionViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var Bell: UILabel!
    @IBOutlet weak var MentiontableView: UITableView!
    
    
    // MARK: - Variables
    var sendMentionToBDelegate: sendMentionToBDelegate?
    
    let Bellnotice: [String] = ["雷達 (預設值)", "上升", "山坡", "公告", "水晶", "宇宙", "波浪", "信號", "急板", "指標"]
    var saveMention: String = ""
    var saveBMention: String = ""
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("transport \(saveBMention)")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendMentionToBDelegate?.sendMention(MentionSelect: saveMention)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        self.title = "提示音"
        MentiontableView.delegate = self
        MentiontableView.dataSource = self
        MentiontableView.register(UINib(nibName: "MentionTableViewCell", bundle: nil), forCellReuseIdentifier: MentionTableViewCell.identifier)
    }
    
    // MARK: - IBAction
    
}
// MARK: - Extension

extension MentionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bellnotice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MentiontableView.dequeueReusableCell(withIdentifier: MentionTableViewCell.identifier, for: indexPath) as! MentionTableViewCell
        cell.MentionBellLabel.text = Bellnotice[indexPath.row]
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark"))
        var register_index: Int = 0
        
        cell.accessoryView = nil
        if cell.isSelected {
//            let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark"))
            cell.accessoryView = checkmarkView
        }
        
        if saveBMention != "" {
//            if let index = Bellnotice.firstIndex(of: saveBMention) {
//                if indexPath.row == index {
//                    cell.accessoryView = checkmarkView
//                }
//            }
            for (i, n) in Bellnotice.enumerated() {
                if saveBMention == n.prefix(2) {
                    register_index = i
                }
            }
            if indexPath.row == register_index {
                cell.accessoryView = checkmarkView
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        for cell in tableView.visibleCells {
            if cell != selectedCell {
                cell.accessoryView = nil
            }
        }
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark"))
        selectedCell?.accessoryView = checkmarkView
        saveMention = Bellnotice[indexPath.row]
        
    }
}
// MARK: - Protocol

protocol sendMentionToBDelegate {
    func sendMention(MentionSelect: String)
}

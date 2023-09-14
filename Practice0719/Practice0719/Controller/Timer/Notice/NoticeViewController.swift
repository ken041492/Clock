//
//  NoticeViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/9/1.
//

import UIKit

class NoticeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    var leftBarButton_cancle: UIBarButtonItem?
    var rightBarButton_save: UIBarButtonItem?
    var sendMessage: SendMessage?
    var reloadTimerTableView: ReloadTableViewDelegate?

    let Bellnotice: [String] = ["雷達 (預設值)", "上升", "山坡", "公告", "水晶", "宇宙", "波浪", "信號", "急板", "指標"]
    var saveMention: String = ""
    var registerMention: String = ""
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reloadTimerTableView?.reloadtableview()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        self.title = "當計時結束"

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: NoticeTableViewCell.identifier)
        tableView.layer.borderWidth = 0.5
        tableView.layer.cornerRadius = 10.0
        tableView.clipsToBounds = true
    }
    
    func setupBNavigation() {
        

        leftBarButton_cancle = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancle_BTN))
        rightBarButton_save = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(set_BTN))
        
        leftBarButton_cancle?.tintColor = UIColor.orange
        rightBarButton_save?.tintColor = UIColor.orange
        
        navigationItem.leftBarButtonItem = leftBarButton_cancle
        navigationItem.rightBarButtonItem = rightBarButton_save
        
    }
    
    // MARK: - IBAction
    @objc func cancle_BTN() {
        dismiss(animated: true)
    }
    
    @objc func set_BTN() {
        sendMessage?.sendMessage(Message: saveMention)
        print(saveMention)
        dismiss(animated: true)
    }
}
// MARK: - Extension
extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bellnotice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as! NoticeTableViewCell
        cell.noticeLabel.text = Bellnotice[indexPath.row]
        let checkmarkView = UIImageView(image: UIImage(systemName: "checkmark"))
        if registerMention != "" {
            for (i, n) in Bellnotice.enumerated() {
                if registerMention == n.prefix(2) {
                    let register_index = i
                    if indexPath.row == register_index {
                        cell.accessoryView = checkmarkView
                        cell.tintColor = UIColor.orange

                    }
                }
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
        selectedCell?.tintColor = UIColor.orange
        saveMention = Bellnotice[indexPath.row]
        
        if saveMention == Bellnotice[0] {
            saveMention = "雷達"
        }
    }
}
// MARK: - Protocol

protocol SendMessage {
    func sendMessage(Message: String)
}


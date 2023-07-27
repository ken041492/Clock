//
//  RepeatViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/24.
//

import UIKit

class RepeatViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var RepeatTableView: UITableView!
    
    
    // MARK: - Variables
    let week: [String] = ["星期日", "星期一", "星期二","星期三", "星期四", "星期五", "星期六"]
    let weekToLabel: [String] = ["週日", "週一", "週二", "週三", "週四", "週五", "週六"]
    var saveWeek: String = ""
    var isSelected: [Int] = []
    var sendWeekToBDelegate: sendWeekToBDelegate?
    var reloadBView: ReloadTableViewDelegate?
    var getBweekLabel: String = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重複"
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
//        print("my week \(getBweekLabel)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        writeLabel()
        sendWeekToBDelegate?.sendWeek(weekSelect: saveWeek)
        reloadBView?.reloadtableview()
//        print("Selected \(isSelected)")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        
        RepeatTableView.delegate = self
        RepeatTableView.dataSource = self
        RepeatTableView.register(UINib(nibName: "BRPTableViewCell", bundle: nil), forCellReuseIdentifier: BRPTableViewCell.identifier)
        
        if getBweekLabel != "" {
            let getBWeekArray: [String] = getBweekLabel.components(separatedBy: " ").filter { !$0.isEmpty }
            for week in getBWeekArray {
                let index = week.index(week.startIndex, offsetBy: 1)
                let character = week[index]
                switch character  {
                case "日":
                    isSelected.append(0)
                case "一":
                    isSelected.append(1)
                case "二":
                    isSelected.append(2)
                case "三":
                    isSelected.append(3)
                case "四":
                    isSelected.append(4)
                case "五":
                    isSelected.append(5)
                case "六":
                    isSelected.append(6)
                case "末":
                    isSelected.append(0)
                    isSelected.append(6)
                case "個":
                    for i in 1...5 {
                        isSelected.append(i)
                    }
                default:
                    for i in 0...6 {
                        isSelected.append(i)
                    }
                }
            }
        }
    }
    
    func writeLabel() {
        isSelected.sort{ (num1, num2) -> Bool in
                if num1 == 0 {
                    return false
                } else if num2 == 0 {
                    return true
                } else {
                    return num1 < num2
                }
        }
        if isSelected == [1,2,3,4,5]{
            saveWeek = "每個平日"
        } else if isSelected == [6,0] {
            saveWeek = "週末"
        } else if isSelected.count == 7 {
            saveWeek = "每天"
        } else {
            for i in isSelected {
                saveWeek = saveWeek + weekToLabel[i] + " "
            }
        }
        
    }
    
    // MARK: - IBAction
    
}
// MARK: - Extension
extension RepeatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = RepeatTableView.dequeueReusableCell(withIdentifier: BRPTableViewCell.identifier,
                                                       for: indexPath) as! BRPTableViewCell
        cell.weekLabel.text = week[indexPath.row]
        cell.selectionStyle = .none
        
        if isSelected.contains(indexPath.row){
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor.orange
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelected.contains(indexPath.row) {
            isSelected = isSelected.filter{$0 != indexPath.row}
        } else {
            isSelected.append(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}
// MARK: - Protocol
protocol sendWeekToBDelegate {
    func sendWeek(weekSelect: String)
}


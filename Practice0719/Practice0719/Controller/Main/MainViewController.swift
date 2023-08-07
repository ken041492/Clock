//
//  MainViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import UIKit
import SwiftUI
import RealmSwift
import UserNotifications

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
//    @IBOutlet weak var Label: UILabel!
//    @IBOutlet weak var TextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    var rightBarButton_add: UIBarButtonItem?
    var leftBarButton_edit: UIBarButtonItem?
    var leftBarButtonItem2: UIBarButtonItem?
    var reloadDelegate: ReloadTableViewDelegate?
    var switchStates: [Bool] = []
    var set_period: String = ""
    var set_hours: String = ""
    var set_minutes: String = ""
    var recieve_clock_array: [ClockStruct] = []
    var send_clock_array: [ClockStruct] = []
    var deleteArr_cell: ClockStruct?
    var recieve_weekLabel: String = ""
    var recieveB_Mention: String = ""
    var EditHours: String = ""
    var EditMinutes: String = ""
    var EditWeek: String = ""
    var EditPeriod: String = ""
    var EditIndexPath: Int = 0
    var NowEditting: Bool = false
    var clickEdit: Bool = false
    var selectSwitchindex: Int = 0
    var cell_weekNumber: [Int] = []
    var row: Int = 0
    var uuid: ObjectId!
    var judge_index: Int!
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        print("file: \(realm.configuration.fileURL!)")
        recieve_clock_array = sorted_clock()
        tableView.reloadData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: MainTableViewCell.identified)
        tableView.register(UINib(nibName: "AlartTitleTableViewCell", bundle: nil), forCellReuseIdentifier: AlartTitleTableViewCell.identifier)
        tableView.register(UINib(nibName: "NosettingTableViewCell", bundle: nil), forCellReuseIdentifier: NosettingTableViewCell.identifier)
        tableView.register(UINib(nibName: "OtherTableViewCell", bundle: nil), forCellReuseIdentifier: OtherTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    
        setupNavigation()
        switchStates = Array(repeating: false, count: recieve_clock_array.count)
        
    }
    
    func setupNavigation() {
        
        leftBarButton_edit = UIBarButtonItem(title: "編輯", style: .done, target: self, action: #selector(EditBTN))
        rightBarButton_add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(jumpToBViewController))
        
        leftBarButton_edit?.tintColor = UIColor.orange
        rightBarButton_add?.tintColor = UIColor.orange
        
        navigationItem.leftBarButtonItem = leftBarButton_edit
        navigationItem.rightBarButtonItem = rightBarButton_add
        navigationController!.navigationBar.prefersLargeTitles = true
        title = "鬧鐘"
    }
    
    func sorted_clock() -> [ClockStruct]{
        let realm = try! Realm()
        let sort_result = realm.objects(Clock.self)
            .sorted(by: { (clock1, clock2) -> Bool in
                if let minutes1 = Int(clock1.DB_Minutes),
                   let minutes2 = Int(clock2.DB_Minutes) {
                    return minutes1 < minutes2
                } else {
                    return clock1.DB_Minutes < clock2.DB_Minutes
                }
            })
            .sorted(by: { (clock1, clock2) -> Bool in
                    if let hours1 = Int(clock1.DB_Hours),
                       let hours2 = Int(clock2.DB_Hours) {
                        return hours1 < hours2
                    } else {
                        return clock1.DB_Hours < clock2.DB_Hours
                    }
                })
            .sorted(by: { (clock1, clock2) -> Bool in
                    if let hours1 = Int(clock1.DB_Period),
                       let hours2 = Int(clock2.DB_Period) {
                        return hours1 < hours2
                    } else {
                        return clock1.DB_Period < clock2.DB_Period
                    }
                })
        var register_array: [ClockStruct] = []

        for i in 0..<sort_result.count{
            register_array.append(ClockStruct(uuid: sort_result[i]["uuid"] as! ObjectId, DB_Period: sort_result[i]["DB_Period"] as! String,
                                              DB_Hours: sort_result[i]["DB_Hours"] as! String, DB_Minutes: sort_result[i]["DB_Minutes"] as! String, CurrentTime: sort_result[i]["CurrentTime"] as! String, WeekLabel: sort_result[i]["WeekLabel"] as! String, MentionLabel: sort_result[i]["MentionLabel"] as! String, TagText: sort_result[i]["TagText"] as! String,
                                              SaveSwitch: sort_result[i]["SaveSwitch"] as! Bool, SaveWeekNumber: sort_result[i]["SaveWeekNumber"] as! String)
            )
        }
        return register_array
    }
    
    func createNoticefication() {
        
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let weekday = dateComponents.weekday! - 1
        if cell_weekNumber.count != 0 {
            for i in cell_weekNumber {
                if i == weekday {
                    let content = UNMutableNotificationContent()
                    var dateComponents = DateComponents()
                    if recieve_clock_array[row].DB_Period == "上午" || recieve_clock_array[row].DB_Hours == "12" {
                        dateComponents.hour = Int(recieve_clock_array[row].DB_Hours)
                    } else {
                        dateComponents.hour = Int(recieve_clock_array[row].DB_Hours)! + 12
                    }
                    dateComponents.minute = Int(recieve_clock_array[row].DB_Minutes)

                    content.title = "\(recieve_clock_array[row].DB_Period), \(dateComponents.hour!) : \(dateComponents.minute!) 鬧鐘通知"
                    content.body = "該起床了！"
                    content.sound = .default
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: "\(uuid!)", content: content, trigger: trigger)
           
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if let error = error {
                            print("無法建立鬧鐘通知: \(error)")
                        }
                    }
                }
            }
        } else {
            judge_index = row
            let content = UNMutableNotificationContent()
            var dateComponents = DateComponents()
            if recieve_clock_array[row].DB_Period == "上午" || recieve_clock_array[row].DB_Hours == "12" {
                dateComponents.hour = Int(recieve_clock_array[row].DB_Hours)
            } else {
                dateComponents.hour = Int(recieve_clock_array[row].DB_Hours)! + 12
            }
            dateComponents.minute = Int(recieve_clock_array[row].DB_Minutes)
            content.title = "\(recieve_clock_array[row].DB_Period), \(dateComponents.hour!) : \(dateComponents.minute!) 鬧鐘通知"
            content.body = "該起床了！"
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "\(uuid!)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("無法建立鬧鐘通知: \(error)")
                }
            }
        }
    }
    // MARK: - IBAction
    
    @objc func changeSwitch(_ sender: UISwitch) {
        
        let switchPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: switchPosition), indexPath.row >= 3 {
            row = indexPath.row - 3
            let weeekNumber = recieve_clock_array[row].SaveWeekNumber
            let trimmedString = weeekNumber.trimmingCharacters(in: .whitespacesAndNewlines)
            let numberStrings = trimmedString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",")
            cell_weekNumber = numberStrings.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        }
        for i in 0..<recieve_clock_array.count{
            if i == sender.tag {
                uuid = recieve_clock_array[sender.tag].uuid
                let realm = try! Realm()
                let clock = realm.objects(Clock.self)
                if sender.isOn == true {
                    try! realm.write {
                        clock[sender.tag].SaveSwitch = true
                    }
                    createNoticefication()
                } else {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(uuid!)"])
                    try! realm.write {
                        clock[sender.tag].SaveSwitch = false
                    }
                }
            }
        }
    }
    
    @objc func jumpToBViewController() {
        
        let nextVC = BViewController()
        for cell in tableView.visibleCells {
            if let customCell = cell as? MainTableViewCell {
                customCell.animateLeftCell()
                customCell.NoticeBell.isHidden = false
                customCell.removeArrowSymbol()
            }
        }
        tableView.setEditing(false, animated: false)
        clickEdit = true
        let title = clickEdit ? "編輯" : "完成"
        leftBarButton_edit = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(EditBTN))
        leftBarButton_edit?.tintColor = UIColor.orange
        navigationItem.leftBarButtonItem = leftBarButton_edit
        clickEdit = false
        nextVC.sendMessagToADelegate = self
        nextVC.reloadAView = self
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.isNavigationBarHidden = false
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func EditBTN() {
        let title = clickEdit ? "編輯" : "完成"
        leftBarButton_edit = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(EditBTN))
        leftBarButton_edit?.tintColor = UIColor.orange
        navigationItem.leftBarButtonItem = leftBarButton_edit
        if clickEdit {
            for cell in tableView.visibleCells {
                if let customCell = cell as? MainTableViewCell {
                    customCell.animateLeftCell()
                    customCell.NoticeBell.isHidden = false
                    customCell.removeArrowSymbol()
                }
            }
            clickEdit = false
        } else {
            for cell in tableView.visibleCells {
                if let customCell = cell as? MainTableViewCell {
                    customCell.animateRightCell()
                    customCell.NoticeBell.isHidden = true
                    customCell.addArrowSymbol()
                }
            }
            clickEdit = true
        }
        tableView.setEditing(clickEdit, animated: false)
    }
}
// MARK: - Extension
extension MainViewController: SendMessageToADelegate {
    func sendMessage(period: String, hours: String, minutes: String, clock_array: [ClockStruct], weekLabel: String, MentionLabel: String) {
        set_period = period
        set_hours = hours
        set_minutes = minutes
        recieve_clock_array = clock_array
        recieve_weekLabel = weekLabel
        recieveB_Mention = MentionLabel
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 2 {
            return 80
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recieve_clock_array.count + 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlartTitleTableViewCell.identifier, for: indexPath) as! AlartTitleTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: NosettingTableViewCell.identifier, for: indexPath) as! NosettingTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: OtherTableViewCell.identifier, for: indexPath) as! OtherTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identified, for: indexPath) as! MainTableViewCell
            cell.Period.text = String(recieve_clock_array[indexPath.row - 3].DB_Period)
            cell.ClockTime.text = "\(recieve_clock_array[indexPath.row - 3].DB_Hours):\(recieve_clock_array[indexPath.row - 3].DB_Minutes)"
            cell.indicateWeek.text = recieve_clock_array[indexPath.row - 3].WeekLabel
            cell.NoticeBell.isOn = recieve_clock_array[indexPath.row - 3].SaveSwitch
            cell.NoticeBell.tag = indexPath.row - 3
            cell.NoticeBell.addTarget(self, action: #selector(changeSwitch(_:)), for: .valueChanged)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.row < 3 {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (_, _, completionHandler) in
            let realm = try! Realm()
            if indexPath.row - 3 < self.recieve_clock_array.count {
                self.deleteArr_cell = self.recieve_clock_array[indexPath.row - 3]
                let del_uuid = self.deleteArr_cell?.uuid
                let delect_cell = realm.objects(Clock.self).where {
                    $0.uuid == del_uuid!
                }[0]
                
                try! realm.write {
                    realm.delete(delect_cell)
                }
                
                self.recieve_clock_array.remove(at: indexPath.row - 3)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true) // 告訴系統滑動操作已完成
        }
        deleteAction.backgroundColor = UIColor.red
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 2 {
            let nextVC = BViewController()
            nextVC.sendMessagToADelegate = self
            nextVC.reloadAView = self
            NowEditting = true
            EditIndexPath = indexPath.row - 3
            nextVC.recieve_Tag = recieve_clock_array[EditIndexPath].TagText
            nextVC.recieve_IsEdit = NowEditting
            nextVC.recieve_indexPath = EditIndexPath
            nextVC.recieve_switch = recieve_clock_array[EditIndexPath].SaveSwitch
            nextVC.recieveA_clockArray = recieve_clock_array
            let navigationController = UINavigationController(rootViewController: nextVC)
            navigationController.isNavigationBarHidden = false
                
            for cell in tableView.visibleCells {
                if let customCell = cell as? MainTableViewCell {
                    customCell.animateLeftCell()
                    customCell.NoticeBell.isHidden = false
                    customCell.removeArrowSymbol()
                }
            }
            clickEdit = false
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < 3 {
            return false
        } else {
            return true
        }
    }
    
}

extension MainViewController: ReloadTableViewDelegate {
    func reloadtableview() {
        tableView.reloadData()
    }
}
// MARK: - Protocol
protocol ReloadTableViewDelegate {
    func reloadtableview()
}
protocol SwitchToAlarm {
    func switchtToAlarm()
}

//
//  MainViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import UIKit
import SwiftUI
import RealmSwift

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
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        print("file: \(realm.configuration.fileURL!)")
        for clock in realm.objects(Clock.self){
            let new_clock_struct = ClockStruct(uuid: clock["uuid"] as! ObjectId, DB_Period: clock["DB_Period"] as! String,
                                               DB_Hours: clock["DB_Hours"] as! String, DB_Minutes: clock["DB_Minutes"] as! String, CurrentTime: clock["CurrentTime"] as! String, WeekLabel: clock["WeekLabel"] as! String, MentionLabel: clock["MentionLabel"] as! String)
            recieve_clock_array.append(new_clock_struct)
        }
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
        print("消失囉")
        
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
    }
    
    func setupNavigation() {
        self.title = "鬧鐘"
        leftBarButton_edit = UIBarButtonItem(title: "編輯", style: .done, target: self, action: #selector(EditBTN))
        rightBarButton_add = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(jumpToBViewController))
        
        leftBarButton_edit?.tintColor = UIColor.orange
        rightBarButton_add?.tintColor = UIColor.orange
        
        navigationItem.leftBarButtonItem = leftBarButton_edit
        navigationItem.rightBarButtonItem = rightBarButton_add

    }
    
    // MARK: - IBAction
    
    @objc func jumpToBViewController() {
        
        let nextVC = BViewController()
        nextVC.sendMessagToADelegate = self
        nextVC.reloadAView = self
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.isNavigationBarHidden = false
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func EditBTN() {
//        print(" recieve \(recieve_weekLabel)")
    }
    
    @objc func InitBTN() {
        print("回首頁")
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
            
            nextVC.recieve_IsEdit = NowEditting
            nextVC.recieve_indexPath = EditIndexPath
            nextVC.recieveA_clockArray = recieve_clock_array
            let navigationController = UINavigationController(rootViewController: nextVC)
            navigationController.isNavigationBarHidden = false

            
                
            self.present(navigationController, animated: true, completion: nil)
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


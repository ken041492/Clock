//
//  BViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import UIKit
import RealmSwift

class BViewController: UIViewController {
    
    // MARK: - IBOutlet
//    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var myPickerview: UIPickerView!
    @IBOutlet weak var myBTableview: UITableView!
    @IBOutlet weak var testBTN: UIButton!
    
    
    // MARK: - Variables
    
//    var reciveString = ""
    var sendMessagToADelegate: SendMessageToADelegate?
    var reloadAView: ReloadTableViewDelegate?
    var leftBarButton_cancle: UIBarButtonItem?
    var rightBarButton_save: UIBarButtonItem?
    
    let Period: [String] = ["上午", "下午"]
    let Hours = [Int](1...12)
    let Minutes = [Int](0...59)
    
    var SelectPeriod: String = "上午"
    var SelectHours: String = "1"
    var SelectMinutes: String = "00"
    
    var editedPeriod: String = "上午"
    var editedHours: String = "1"
    var editedMinutes: String = "00"
    
    var AViewWeek: String = ""
    var recieve_Mention: String = ""
    var catchMentionLabel: String = ""
    var clock_array: [ClockStruct] = []
    var catchWeekSelect: String = ""
    var saveWeekToRPV: String = ""
    let addAlarmTitles = ["重複", "標籤", "提示聲", "稍後提醒"]
    let addAlarmDetails = ["永不", "鬧鐘", "雷達"]
    var save_RP_MT: [String] = []

    let week: [String] = ["星期日", "星期一", "星期二","星期三", "星期四", "星期五", "星期六"]
    var recieveA_clockArray: [ClockStruct] = []
    
    var recieve_indexPath: Int = 0
    var recieve_IsEdit: Bool = false
    
    var PickerViewSelected: Bool = false
    
    var PickPeriod: Bool = false
    var PickHours: Bool = false
    var PickMinutes: Bool = false
    
    var initialAmPmIndex: Int = 0
    var initialHourIndex: Int = 0
    var initialMinuteIndex: Int = 0
    
    var editedPeriodIndex: Int = 0
    var editedHoursIndex: Int = 0
    var editedMinutesIndex: Int = 0
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBUI()
//        let realm = try! Realm()
//        print("file: \(realm.configuration.fileURL!)")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        myBTableview.reloadData()
        
//        print("catch \(catchWeekSelect)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendMessagToADelegate?.sendMessage(period: SelectPeriod, hours: SelectHours, minutes: SelectMinutes, clock_array: clock_array, weekLabel: AViewWeek, MentionLabel: catchMentionLabel)
        reloadAView?.reloadtableview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupBUI() {
        
        setupBNavigation()
        myPickerview.delegate = self
        myPickerview.dataSource = self

        myBTableview.register(UINib(nibName: "BTableViewCell", bundle: nil), forCellReuseIdentifier: BTableViewCell.identified)
        myBTableview.register(UINib(nibName: "BMTableViewCell", bundle: nil), forCellReuseIdentifier: BMTableViewCell.identified)
        myBTableview.register(UINib(nibName: "BLTableViewCell", bundle: nil), forCellReuseIdentifier: BLTableViewCell.identified)
        
        myBTableview.delegate = self
        myBTableview.dataSource = self
        myBTableview.isScrollEnabled = false
        
        if recieve_IsEdit && PickerViewSelected == false {
            initialAmPmIndex = Period.firstIndex(of: recieveA_clockArray[recieve_indexPath].DB_Period) ?? 0
            initialHourIndex = Hours.firstIndex(of: Int(recieveA_clockArray[recieve_indexPath].DB_Hours)!) ?? 0
            initialMinuteIndex = Minutes.firstIndex(of: Int(recieveA_clockArray[recieve_indexPath].DB_Minutes)!) ?? 0
            myPickerview.selectRow(initialAmPmIndex, inComponent: 0, animated: false)
            myPickerview.selectRow(initialHourIndex, inComponent: 1, animated: false)
            myPickerview.selectRow(initialMinuteIndex, inComponent: 2, animated: false)
            editedPeriod = Period[initialAmPmIndex]
            editedHours = String(Hours[initialHourIndex])
            if Minutes[initialMinuteIndex] < 10 {
                editedMinutes = "0\(Minutes[initialMinuteIndex])"
            } else {
                editedMinutes = "\(Minutes[initialMinuteIndex])"
            }
        }
    }
    
    func setupBNavigation() {
        
        if recieve_IsEdit {
            self.title = "編輯鬧鐘"
        } else {
            self.title = "加入鬧鐘"
        }
        
        leftBarButton_cancle = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancle_BTN))
        rightBarButton_save = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(add_BTN))
        
        leftBarButton_cancle?.tintColor = UIColor.orange
        rightBarButton_save?.tintColor = UIColor.orange
        
        navigationItem.leftBarButtonItem = leftBarButton_cancle
        navigationItem.rightBarButtonItem = rightBarButton_save
        
    }
    
    func getSystemTime() -> String {
        
        let currectDate = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        return dateFormatter.string(from: currectDate)
    }
    
    
    // MARK: - IBAction
    
    @objc func cancle_BTN() {
        clock_array = []
        let realm = try! Realm()
        let Clock_DB = realm.objects(Clock.self)
        for clock in Clock_DB{
            let new_clock_struct = ClockStruct(uuid: clock["uuid"] as! ObjectId, DB_Period: clock["DB_Period"] as! String,
                                               DB_Hours: clock["DB_Hours"] as! String, DB_Minutes: clock["DB_Minutes"] as! String, CurrentTime: clock["CurrentTime"] as! String, WeekLabel: clock["WeekLabel"] as! String, MentionLabel: clock["MentionLabel"] as! String)
            clock_array.append(new_clock_struct)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func add_BTN() {
        
        let realm = try! Realm()
        let Clock_DB = realm.objects(Clock.self)
        if recieve_IsEdit {
            try! realm.write {
                Clock_DB[recieve_indexPath].DB_Period = editedPeriod
                Clock_DB[recieve_indexPath].DB_Hours = editedHours
                Clock_DB[recieve_indexPath].DB_Minutes = editedMinutes
                Clock_DB[recieve_indexPath].WeekLabel = "鬧鐘," + AViewWeek
                Clock_DB[recieve_indexPath].MentionLabel = recieve_Mention
            }
            recieve_IsEdit = false
        } else {
            try! realm.write {
                realm.add(Clock(DB_Period: editedPeriod, DB_Hours: editedHours, DB_Minutes: editedMinutes, CurrentTime: getSystemTime(), WeekLabel: "鬧鐘, \(AViewWeek)", MentionLabel: recieve_Mention))
            }
        }
        clock_array = []
        for clock in Clock_DB{
            let new_clock_struct = ClockStruct(uuid: clock["uuid"] as! ObjectId, DB_Period: clock["DB_Period"] as! String,
                                               DB_Hours: clock["DB_Hours"] as! String, DB_Minutes: clock["DB_Minutes"] as! String, CurrentTime: clock["CurrentTime"] as! String, WeekLabel: clock["WeekLabel"] as! String, MentionLabel: clock["MentionLabel"] as! String)
            clock_array.append(new_clock_struct)
        }
        
        dismiss(animated: true)
    }
}
// MARK: - Extension

extension BViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Period.count
        } else if component == 1 {
            return Hours.count
        } else {
            return Minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
      titleForRow row: Int, forComponent component: Int)
    -> String? {
        if component == 0 {
            return Period[row]
        } else if component == 1 {
            return "\(Hours[row])"
        } else {
            if Minutes[row] < 10 {
                return "0\(Minutes[row])"
            } else {
                return "\(Minutes[row])"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
      didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            SelectPeriod = Period[row]
            PickPeriod = true
        } else if component == 1 {
            SelectHours = "\(Hours[row])"
            PickHours = true
        } else {
            SelectMinutes = "\(Minutes[row])"
            PickMinutes = true
        }
        PickerViewSelected = true

        editedPeriodIndex = myPickerview.selectedRow(inComponent: 0)
        editedHoursIndex = myPickerview.selectedRow(inComponent: 1)
        editedMinutesIndex = myPickerview.selectedRow(inComponent: 2)
        
        editedPeriod = Period[editedPeriodIndex]
        editedHours = "\(Hours[editedHoursIndex])"
        if Minutes[editedMinutesIndex] < 10 {
            editedMinutes = "0\(Minutes[editedMinutesIndex])"
        } else {
            editedMinutes = "\(Minutes[editedMinutesIndex])"
        }
        
    }
        
        
        
}

extension BViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addAlarmTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 3:
            let cell = myBTableview.dequeueReusableCell(withIdentifier: BMTableViewCell.identified, for: indexPath) as! BMTableViewCell
            cell.mentionLabel.text = addAlarmTitles[indexPath.row]
            return cell
        case 1:
            let cell = myBTableview.dequeueReusableCell(withIdentifier: BLTableViewCell.identified, for: indexPath) as! BLTableViewCell
            cell.Label.text = addAlarmTitles[indexPath.row]
            return cell
        default:
            let cell = myBTableview.dequeueReusableCell(withIdentifier: BTableViewCell.identified, for: indexPath) as! BTableViewCell
            
            if indexPath.row == 0 || indexPath.row == 2 {
                cell.addArrowSymbol()
            } else {
                cell.removeArrowSymbol()
            }
            
            cell.titlelabel.text = addAlarmTitles[indexPath.row]
            if catchWeekSelect == "" {
                if recieve_IsEdit {
                    let saveWeek = recieveA_clockArray[recieve_indexPath].WeekLabel.components(separatedBy: ",")[1]
                    if saveWeek == " " {
                        cell.optionlabel.text = addAlarmDetails[indexPath.row]
                    } else {
                        if indexPath.row != 2 {
                            cell.optionlabel.text = saveWeek
                            AViewWeek = cell.optionlabel.text!
                        } else {
                            cell.optionlabel.text = addAlarmDetails[indexPath.row]
                        }
                    }
                } else {
                    cell.optionlabel.text = addAlarmDetails[indexPath.row]
                }
            } else {
                
                save_RP_MT.append(catchWeekSelect)
                cell.optionlabel.text = save_RP_MT[0]
                AViewWeek = cell.optionlabel.text!
                catchWeekSelect = ""
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let repeatVC = RepeatViewController()
            repeatVC.sendWeekToBDelegate = self
            repeatVC.getBweekLabel = AViewWeek
            let newBackButton = UIBarButtonItem()
            newBackButton.title = "返回"
            navigationItem.backBarButtonItem = newBackButton
            navigationController?.navigationBar.tintColor = .orange
            navigationController?.pushViewController(repeatVC, animated: true)
        case 2:
            let MentionVC = MentionViewController()
            let newBackButton = UIBarButtonItem()
            newBackButton.title = "返回"
            navigationItem.backBarButtonItem = newBackButton
            navigationController?.navigationBar.tintColor = .orange
            navigationController?.pushViewController(MentionVC, animated: true)
        default:
            break
        }
    }
}

extension BViewController: sendWeekToBDelegate, ReloadTableViewDelegate, sendMentionToBDelegate {
    func sendWeek(weekSelect: String) {
        catchWeekSelect = weekSelect
    }

    func reloadtableview() {
        myBTableview.reloadData()
    }
    
    func sendMention(MentionSelect: String) {
        catchMentionLabel = MentionSelect
    }
}

// MARK: - Protocol

protocol SendMessageToADelegate {
    func sendMessage(period: String, hours: String, minutes: String, clock_array: [ClockStruct], weekLabel: String, MentionLabel: String)
}


